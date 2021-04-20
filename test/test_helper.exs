:application.load(:opentelemetry)
:application.set_env(:opentelemetry, :tracer, :otel_tracer_default)

:application.set_env(:opentelemetry, :processors, [
  {:otel_batch_processor, %{scheduled_delay_ms: 1}}
])

Application.ensure_all_started(:opentelemetry)
Application.ensure_all_started(:telemetry)

ExUnit.start()
