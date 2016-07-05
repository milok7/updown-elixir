defmodule Updown.Check do
	@moduledoc ~S"""
		Provides a struct for a check
	"""

	defstruct [:token, :url, :alias, :last_status, :uptime, :down, :down_since, :error, :period, :apdex_t, :string_match, :enabled, :published, :last_check_at, :next_check_at, :favicon_url, ssl: [:tested_at, :valid, :error]]
	
end