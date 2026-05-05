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

  def application do
    [
      extra_applications: [:logger],
      mod: {GimnasioApp, []}
    ]
  end

  defp deps do
    [
      {:nimble_csv, "~> 1.2"}
    ]
  end
end
