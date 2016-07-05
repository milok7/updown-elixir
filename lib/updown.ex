
defmodule Updown do
	@moduledoc ~S"""
		Global variables: url for http calls and your API key.
	"""

	@doc ~S"""
		Your API key goes here
	"""
	def apikey do "YOUR-API-KEY" end

	def url do "https://updown.io/api/checks" end
	
end