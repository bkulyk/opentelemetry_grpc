defmodule OpentelemetryGrpc.MixProject do
  use Mix.Project

  def project do
    [
      app: :opentelemetry_grpc,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:grpc, "~> 0.5.0-beta", allow_pre: true},
      {:inflex, "~> 2.1", allow_pre: true},
      {:opentelemetry_api, "~> 1.0.0-rc", allow_pre: true},
      {:opentelemetry, "~> 1.0.0-rc", allow_pre: true},
      {:mock, "~> 0.3.6", only: [:dev, :test]}
    ]
  end
end
