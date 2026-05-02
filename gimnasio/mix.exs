defmodule Gimnasio.MixProject do
  use Mix.Project

  def project do
    [
      app: :gimnasio,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
       extra_applications: [:logger],
       mod: {Menu, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_csv, "~> 1.2"}
    ]
  end
end
