defmodule OpentelemetryGrpc do
  defmodule Server do
    @moduledoc """
    Add OpenTelementry to gRPC server calls
    ## Usage
        defmodule Your.Endpoint do
          use GRPC.Endpoint
          intercept OpentelemetryGrpc.Server, enabled: true
        end
    """
    require OpenTelemetry.Tracer, as: Tracer
    @behaviour GRPC.ServerInterceptor

    def init(opts) do
      Keyword.get(opts, :enabled, true)
    end

    def call(req, %{grpc_type: :unary} = stream, next, true) do
      Tracer.with_span(OpentelemetryGrpc.span_name(stream)) do
        result = next.(req, stream)

        # set some grpc attributes on the trace
        Tracer.set_attribute("grpc.status_code", OpentelemetryGrpc.grpc_status(result))
        Tracer.set_attribute("kind", 1) #  INTERNAL: 0, SERVER: 1, CLIENT: 2, PRODUCER: 3, CONSUMER: 4

        # k thx bye
        result
      end
    end

    def call(req, %{grpc_type: _} = stream, next, _) do
      # not handeling non-unary
      next.(stream, req)
    end
  end

  defmodule Client do
    require OpenTelemetry.Tracer, as: Tracer
    @behaviour GRPC.ClientInterceptor

    def init(opts) do
      Keyword.get(opts, :enabled, true)
    end

    def call(%{grpc_type: :unary} = stream, req, next, true) do
      IO.inspect "here"
      Tracer.with_span(OpentelemetryGrpc.span_name(stream)) do
        result = next.(stream, req)

        # set some grpc attributes on the trace
        Tracer.set_attribute("grpc.status_code", OpentelemetryGrpc.grpc_status(result))
        Tracer.set_attribute("kind", 2) #  INTERNAL: 0, SERVER: 1, CLIENT: 2, PRODUCER: 3, CONSUMER: 4

        # k thx bye
        result
      end
    end

    def call(%{grpc_type: _} = stream, req, next, _opts) do
      # not handeling non-unary
      next.(stream, req)
    end
  end

  def span_name(stream) do
    "grpc." <> stream.service_name <> "/" <> Inflex.camelize(to_string(elem(stream.rpc, 0)))
  end

  def grpc_status(result) do
    case elem(result, 0) do
      :ok -> "1"
      _ -> "2"
    end
  end
end
