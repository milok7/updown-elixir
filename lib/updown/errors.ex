defmodule Updown.Error do
	@moduledoc false

	@doc ~S"""
		A basic error message, if the error being thrown is not known
	"""
	@spec message(atom):: binary
	defexception message: "An unknown error has occurred"
end