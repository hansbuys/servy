defmodule ServyTest do
  use ExUnit.Case, async: true
  require Logger

  setup_all do
    port = 8082
    server = spawn(fn -> Servy.accept(port) end)

    on_exit fn -> Process.delete(server) end

    {:ok,
      port: port,
      url: 'http://localhost:#{port}'
    }
  end

  test "/ returns 200 OK and body", context do
      {:ok, {{_, statusCode, statusReason}, _, body}} = :httpc.request(context[:url])
      assert statusCode == 200
      assert List.to_string(statusReason) == "OK"
      assert List.to_string(body) =~ "Pistons, Tigers, RedWings"
  end

  test "/invalid returns 404 NotFound", context do
    result = :httpc.request(context[:url] ++ '/invalid')
    Logger.info(inspect result)
    {:ok, {{_, statusCode, statusReason}, _, _}} = result
    assert statusCode == 404
    assert List.to_string(statusReason) == "Not Found"
  end
end
