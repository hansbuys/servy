defmodule ServyTest do
  use ExUnit.Case
  require Logger

  test "/ returns OK" do
    port = 8082
    server = spawn fn -> Servy.accept(port) end

    {:ok, _} = :httpc.request('http://localhost:8082/')

    Process.delete(server)
  end
end
