defmodule Updown.Mixfile do
  use Mix.Project

  def project do
    [app: :updown,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: description,
     package: package, 
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpotion]]
  end

  defp description do
    """
    A library that interacts with the updown.io API.
    The library supports a few basic fetch functions that retrieves site checks and data about each of them, it also has a few edit functions that changes site checks to suit your needs.
    """
  end


defp package do
  [
   files: ["lib", "mix.exs", "README.md"],
   maintainers: ["milesellery"],
   licenses: ["Apache 2.0"],
   links: %{"Docs" => "http://hexdocs.pm/updown-library/", "Github" => "https://github.com/milok7/updown-elixir"}
   ]
end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:poison, "~> 2.0"},
      {:httpotion, "~> 3.0.0"},
      {:ex_doc, "~> 0.12", only: :dev},
      {:earmark, "~> 0.1", only: :dev}, 
      {:dialyxir, "~> 0.3", only: [:dev]}
    ]
  end
end
