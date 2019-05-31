defmodule OVA.MixProject do
  use Mix.Project

  def project do
    [
      app: :ova,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :pdf_generator]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:poison, "~> 4.0.1"},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      { :pdf_generator, ">=0.5.3" },
      {:sneeze, "~> 1.1"}
    ]
  end
end
