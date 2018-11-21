defmodule ServyTest do
  use ExUnit.Case
  require Logger

  test "/ returns OK" do
    port = 8082
    server = spawn(fn -> Servy.accept(port) end)

    try do
      {:ok, {{_, status, _}, _, body}} = :httpc.request('http://localhost:#{port}/')
      assert status == 200
      assert List.to_string(body) =~ "Pistons, Tigers, RedWings"
    after
      Process.delete(server)
    end
  end
end
