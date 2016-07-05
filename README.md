# Updown

A library that interacts with the updown.io API.

## Installation

If [available in Hex](https://hex.pm/docs/publish)

The package can be installed as:

  1. Add `updown` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:updown, "~> 0.1.0"}]
    end
    ```

  2. Ensure `updown` is started before your application:

    ```elixir
    def application do
      [applications: [:updown]]
    end
    ```

  ##Configuration

  Ensure the config.exs file contains your API key

    ```elixir
    #config/config.exs
      config :updown, key: "YOUR-API-KEY"
    ```
    Change `YOUR-API-KEY` to your API key that can be found at your [settings page](https://updown.io/settings/edit)

    OR

    Use `Application.put_env(:updown, :key, "YOUR-API-KEY")` to change it at any time

  ##Usage

  ###Checks:
  List all checks:
  ```elixir
  Updown.Checks.get_list
  #[%Updown.Check{...}, %Updown.Check{...}] # <-- if you have two checks

  Updown.Checks.get_list 
  #[] # <-- if you have no checks
  ```

  Retrieve a specific check:
  ```elixir
  Updown.Checks.get_token("qqqq")
  #%Updown.Checks{...}
  ```

  List downtimes for a check:
  ```elixir
  Updown.Checks.get_downtimes("rrrr")
  #[%Updown.Downtime{...}, Updown.Downtime{...}, ...] # <-- defaults to page 1 of downtimes

  Updown.Checks.get_downtimes("oooo", 3)
  #[%Updown.Downtime{...}] # <-- to get from page 3 of downtimes, each page contains a list of 100 downtimes
  ```

  List metrics for a check:
  ```elixir
  Updown.Checks.get_metrics("qqqq")
  #%Updown.Metric{...} # <-- if token exists in your list of checks

  from = %DateTime{calendar: Calendar.ISO, day: 25, hour: 13, microsecond: {868569, 6}, minute: 26, month: 5, second: 8, std_offset: 0, time_zone: "Etc/UTC", utc_offset: 0, year: 2016, zone_abbr: "UTC"}
  Updown.Checks.get_metrics("oooo", from: from, to: DateTime.utc_now, group: "host")
  #%{host, %Updown.Metric{...}, host, %Updown.Metric{...}, ...}

  Updown.Checks.get_metrics("qqqq", from: "2016-06-15 13:37:23")
  #%Updown.Metric{...}
  ```

  ###Edits:
  Add a new check:
  ```elixir
  Updown.Edits.add_new("facebook.com", period: 600)
  #%Updown.Check{url: "facebook.com", period: 600, apdex_t: 0.5, enabled: true, published: false, alias: "", string_match:""}

  Updown.Edits.add_new("youtube.com", published: true, alias: "yutuub")
  #%Updown.Check{url: "youtube.com", period: 60, apdex_t: 0.5, enabled: true, published: true, alias: "yutuub", string_match:""}
  ```

  Change a check:
  ```elixir
  Updown.Edits.update("qqqq", url: "facebook.com", period: 600)
  #%Updown.Check{url:"buzzfeed.com", period: 600, ...}

  q = Updown.Edits.add_new("facebook.com")
  Updown.Edits.update(q.token, apdex_t: 1.0, published: true)
  #%Updown.Check{q | published: true, apdex_t: 1.0}
  ```

  Remove a check:
  ```elixir
  Updown.Edits.remove("qqqq")
  #%{:deleted => false} # <-- if the check was not deleted

  Updown.Edits.remove("lqzx")
  #%{:deleted => true} # <-- if the check was deleted
  ```
