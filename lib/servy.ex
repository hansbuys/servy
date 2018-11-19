defmodule Servy do
  require Logger

  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :response` - receives data response by response
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #

    case :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true]) do
      {:ok, socket} ->
        Logger.info("Accepting connections on port #{port}.")
        loop_acceptor(socket)

      {:error, reason} ->
        Logger.error("Could not listen: #{reason}.")
    end
  end

  defp loop_acceptor(socket) do
    case :gen_tcp.accept(socket) do
      {:ok, client} ->
        serve(client)
        loop_acceptor(socket)

      {:error, reason} ->
        Logger.error("No longer accepting connections. #{reason}.")
    end
  end

  defp serve(socket) do
    socket
    |> read_lines
    |> respond(socket)
  end

  defp read_lines(socket) do
    read_line(socket, "")
  end

  defp read_line(socket, lines) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, line} ->
        Logger.info("Received line: '#{line}'.")
        if !Regex.match?(~r/^[\r|\n|\r\n|\n\r]$/, line) do
          read_line(socket, "#{lines}#{line}")
        end
        Logger.info("Received all lines: #{lines}#{line}")
        "#{lines}#{line}"

      {:error, reason} ->
        Logger.info("Closed for #{reason}.")
        :stop
    end
  end

  defp respond(:stop, _socket) do
    :stop
  end

  defp respond(data, socket) do
    Logger.info("Received: '#{data}'")
    response = Servy.Handler.handle(data)
    :gen_tcp.send(socket, response)
  end
end

Servy.accept(8080)
