defmodule OpentelemetryGrpcTest do
  use ExUnit.Case
  doctest OpentelemetryGrpc

  # require Record

  # for {name, spec} <- Record.extract_all(from_lib: "opentelemetry/include/otel_span.hrl") do
  #   Record.defrecord(name, spec)
  # end

  # setup do
  #   :otel_batch_processor.set_exporter(:otel_exporter_pid, self())
  #   :ok
  # end

  # test "server wraps unary call in a span, span is named" do
  #   opts = OpentelemetryGrpc.Server.init(enabled: true)
  #   stream = %{grpc_type: :unary, service_name: "test_space.Test", rpc: {:thing}}

  #   OpentelemetryGrpc.Server.call(%{}, stream, fn(_req, _stream) -> {:ok, "done"} end, opts)

  #   assert_receive {:span, span(attributes: _attributes)}
  # end

  test "span_name is service name, combined with rpc func name" do
    stream = %{
      service_name: "name_space.ServiceName",
      rpc: {:function_name}
    }

    assert OpentelemetryGrpc.span_name(stream) == "grpc.name_space.ServiceName/FunctionName"
  end

  test "grpc status for :ok is 1" do
    assert OpentelemetryGrpc.grpc_status({:ok, "a thing"}) == "1"
    assert OpentelemetryGrpc.grpc_status({:error, "a thing"}) == "2"
  end
end
