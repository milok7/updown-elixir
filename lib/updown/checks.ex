
defmodule Updown.Checks do
	@moduledoc ~S"""
		Provides functions for retrieving information about checks
	"""

	@doc ~S"""
		Retrieves a list of all current checks.

		## Examples
		
			iex> Updown.Checks.get_list
			[%Updown.Check{...}, %Updown.Check{...}] # <-- if you have two checks
			iex> Updown.Checks.get_list 
			[] # <-- if you have no checks
	"""
	@spec get_list() :: list(%Updown.Check{})
	def get_list do
		args = URI.encode_query(%{"api-key" => Application.get_env(:updown, :key)})
		b = HTTPotion.get(Updown.url<>"?"<>args)
		if b.body != "{\"error\":\"Invalid API key\"}" do
			Poison.decode!(b.body, as: [%Updown.Check{}])
		else
			raise Updown.Error, message: "Invalid API key"
		end

	end

	@doc ~S"""
		Retrieves a single check with the specified token

		## Examples

			iex> Updown.Checks.get_token("qqqq")
			%Updown.Checks{...}
			iex> Updown.Checks.get_token("rrrr")
			%Updown.Checks{...}
	"""
	@spec get_token(binary) :: %Updown.Check{}
	def get_token(token) do
		args = URI.encode_query(%{"api-key"=> Application.get_env(:updown, :key)})
		b = HTTPotion.get(Updown.url<>"/"<>token<>"?"<>args)
		case b.body do
			"{\"error\":\"Invalid API key\"}" -> raise Updown.Error, message: "Invalid API key"
			"{\"error\":\"Invalid token:"<>_ -> raise Updown.Error, message: "Invalid token"
			_ -> Poison.decode!(b.body, as: %Updown.Check{})
		end
	end

	@doc ~S"""
		Retrieves the downtimes for a given check with the specified token

		## Examples

			iex> Updown.Checks.get_downtimes("rrrr")
			[%Updown.Downtime{...}, %Updown.Downtime{...}]
			iex> Updown.Checks.get_downtimes("oooo", 4)
			[] # <-- if no downtimes on specified page
	"""
	@spec get_downtimes(binary, integer) :: list(%Updown.Downtime{})
	def get_downtimes(token, page\\1) do
		args = URI.encode_query(%{"page" => page , "api-key"=> Application.get_env(:updown, :key)})
		b = HTTPotion.get(Updown.url<>"/"<>token<>"/downtimes?"<>args)
		case b.body do
			"{\"error\":\"Invalid API key\"}" -> raise Updown.Error, message: "Invalid API key"
			"{\"error\":\"Invalid token:"<>_ -> raise Updown.Error, message: "Invalid token"
			_ -> Poison.decode!(b.body, as: [%Updown.Check{}])
		end
	end

	@doc ~S"""
		Retrieves the metrics for a check with the specified token. For the input time, a DateTime struct may be used or a binary in the format "yyyy-mm-dd hh-mm-ss"
		

		Available options are:
			:from (binary or DateTime)
			:to (binary or DateTime)
			:group (binary) #can group by "time" or "host"

		## Examples

			iex> Updown.Checks.get_metrics("qqqq")
			%Updown.Metric{...} # <-- if token exists in your list of checks
			from = %DateTime{calendar: Calendar.ISO, day: 25, hour: 13, microsecond: {868569, 6}, minute: 26, month: 5, second: 8, std_offset: 0, time_zone: "Etc/UTC", utc_offset: 0, year: 2016, zone_abbr: "UTC"}
			iex> Updown.Checks.get_metrics("oooo", from: from, to: DateTime.utc_now, group: "host")
			{host, %Updown.Metric{...}, host, %Updown.Metric{...}, ...}
			iex> Updown.Checks.get_metrics("qqqq", from: "2016-06-15 13:37:23")
			%Updown.Metric{...}
	"""
	@spec get_metrics(binary, list) :: (struct)
	def get_metrics(token, options\\[]) do
		frm = options[:from]||%{DateTime.utc_now | month: DateTime.utc_now.month-1}
		to = options[:to]||DateTime.utc_now
		if options[:group]==nil do
			args = URI.encode_query(%{"from" => frm, "to" => to, "api-key" => Application.get_env(:updown, :key)})
			b = HTTPotion.get((Updown.url<>"/"<>token<>"/metrics?"<>args))
			Poison.decode!(b.body, as: %Updown.Metric{})
		else
			args = URI.encode_query(%{"from" => frm, "to" => to, "group" => (options[:group]), "api-key" => Application.get_env(:updown, :key)})
			b = HTTPotion.get((Updown.url<>"/"<>token<>"/metrics?"<>args))
			decoded = Poison.decode!(b.body, as: %{})
			Enum.map(decoded,
				fn ({grp, metric}) -> 
					{grp, Poison.decode!(Poison.encode!(metric), as: %Updown.Metric{}, keys: :atoms)}
				end)
		end
	end

end