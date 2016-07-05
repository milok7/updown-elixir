defmodule Updown.Downtime do
	@moduledoc ~S"""
		Provides a struct for the downtime properties of a check
	"""
	defstruct [:error, :started_at, :ended_at, :duration]
end