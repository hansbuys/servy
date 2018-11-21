defmodule ServyTest do
  use ExUnit.Case

  test "/ returns OK" do
    port = 8082
    server = spawn(fn -> Servy.accept(port) end)

    try do
      {:ok, {{_, status, _}, _, _}} = :httpc.request('http://localhost:#{port}/')
      assert status == 200
    after
      Process.delete(server)
    end
  end
end
