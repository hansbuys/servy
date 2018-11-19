defmodule Servy.Handler do
  require Logger

  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def parse(request) do
    %{method: parseMethod(request), path: parsePath(request), body: ""}
  end

  def parsePath(request) do
    secondWord = ~r/^(?:\S+\s){1}(\S+)/
    path = Regex.run(secondWord, request)
    List.last(path)
  end

  def parseMethod(request) do
    firstWord = ~r/^([\w\-]+)/
    method = Regex.run(firstWord, request)
    List.first(method)
  end

  def log(conv) do
    Logger.info("Called #{conv.method} at #{conv.path}")
    conv
  end

  def route(conv) do
    %{
      method: conv.method,
      path: conv.path,
      body: "Pistons, Tigers, RedWings"
    }
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conv.body)}

    #{conv.body}
    """
  end
end
