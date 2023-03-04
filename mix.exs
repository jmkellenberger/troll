defmodule Troll.MixProject do
  use Mix.Project

  @source_url "https://github.com/jmkellenberger/troll"

  def project do
    [
      app: :troll,
      version: "1.0.0",
      elixir: "~> 1.0",
      description: description(),
      source_url: @source_url,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    "Simple implementation of standard dice notation"
  end

  defp deps do
    [
      {:dialyxir, "~> 1.1.0", only: [:dev, :test], runtime: false}
    ]
  end
end
