defmodule Updown.Edits do
	@moduledoc ~S"""
		Functions for changing/adding/deleting your updown.io checks
	"""

	@doc ~S"""
		Adds a new check with specified options


		Usable options with their default values are:
			:period (integer) = 60
			:apdex_t (float) = 0.5
			:enabled (boolean) = true
			:published (boolean) = false
			:alias (binary) = ""
			:string_match (binary) = "" 

		## Examples

			iex> Updown.Edits.add_new("facebook.com", period: 600)
			%Updown.Check{url: "facebook.com", period: 600, apdex_t: 0.5, enabled: true, published: false, alias: "", string_match:""}
			iex> Updown.Edits.add_new("youtube.com", published: true, alias: "yutuub")
			%Updown.Check{url: "youtube.com", period: 60, apdex_t: 0.5, enabled: true, published: true, alias: "yutuub", string_match:""}
	"""

	@spec add_new(binary, keyword) :: %Updown.Check{}
	def add_new(url, options \\[]) do
		header = [{"Accept", "application/json"}, {"Content-Type", "application/json"}]
		args = URI.encode_query(%{"api-key"=> Application.get_env(:updown, :key)})
		bdy = Poison.encode!(%{url: url, period: (options[:period]||60), apdex_t: (options[:apdex_t]||0.5), enabled: (options[:enabled]||true), published: (options[:published]||false), alias: (options[:alias]||""), string_match: (options[:string_match]||"")})
		p = HTTPotion.post(Updown.url<>"?"<>args,[headers: header, body: bdy])
		Poison.decode!(p.body, as: %Updown.Check{})
	end

		@doc ~S"""
		Updates a check with the specified parameters

		
		Usable options are:
			:url (binary)
			:period (integer)
			:apdex_t (float)
			:enabled (boolean)
			:published (boolean)
			:alias (binary)
			:string_match (binary) 

		## Examples
		
			iex> Updown.Edits.update("qqqq", url: "facebook.com", period: 600)
			%Updown.Check{url:"buzzfeed.com", period: 600, ...}
			iex> q = Updown.Edits.add_new("facebook.com")
			iex> Updown.Edits.update("pppp", apdex_t: 1.0, published: true)
			%Updown.Check{q | published: true, apdex_t: 1.0}

	"""
	@spec update(binary, list) :: %Updown.Check{}
	def update(token, options \\[]) do
		header = [{"Accept", "application/json"}, {"Content-Type", "application/json"}]
		chk = Updown.Checks.get_token(token)
		bdy = Poison.encode!(%{url: (options[:url]||chk.url), period: (options[:period]||chk.period), apdex_t: (options[:apdex_t]||chk.apdex_t), enabled: (options[:enabled]||chk.enabled), published: (options[:published]||chk.published), alias: (options[:alias]||chk.alias), string_match: (options[:string_match]||chk.string_match)})
		args = URI.encode_query(%{"api-key"=> Application.get_env(:updown, :key)})
		p = HTTPotion.put(Updown.url<>"/"<>token<>"?"<>args,[headers: header, body: bdy])
		Poison.decode!(p.body, as: %Updown.Check{})
	end

	@doc ~S"""
		Removes a check with the given token, if a check was deleted by the call, the returned boolean will give a true value.

		## Examples

			iex> Updown.Edits.remove("qqqq")
			%{:deleted => false} # <-- if the check was not deleted
			iex> Updown.Edits.remove("lqzx")
			%{:deleted => true} # <-- if the check was deleted

	"""
	@spec remove(binary) :: %{atom => boolean}
	def remove(token) do
		args = URI.encode_query(%{"api-key"=> Application.get_env(:updown, :key)})
		p = HTTPotion.delete(Updown.url<>"/"<>token<>"?"<>args)
		case p.body do
			"{\"error\":\"Invalid API key\"}" -> raise Updown.Error, message: "Invalid API key"
			"{\"error\":\"Invalid token:"<>_ -> raise Updown.Error, message: "Invalid token"
			_ -> Poison.decode!(p.body, keys: :atoms)
		end
	end

end