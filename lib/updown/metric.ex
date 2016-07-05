defmodule Updown.Metric do
	@moduledoc ~S"""
		Provides a struct for the metric properties of a check
	"""
	defstruct [:apdex, requests: [:samples, :failures, :satisfied, :tolerated, 
	 by_response_time: [:under125, :under250, :under500, :under1000, :under2000, :under4000]], 
	 timings: [:redirect, :namelookup, :connection, :handshake, :response, :total]]
end