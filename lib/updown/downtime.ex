defmodule Updown.Downtime do
	@moduledoc false
	defstruct [:error, :started_at, :ended_at, :duration]
end