defmodule Servy.Handler do
  require Logger

  def handle(request) do
    request
    |> parse
    |> log
    |> route
  end

  defmodule Route do
    defstruct method: "GET", path: "/"
  end

  def parse(request) do
    %Route {
      method: parseMethod(request),
      path: parsePath(request)
    }
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

  def log(%Route{} = route) do
    Logger.info("Called #{route.method} at #{route.path}")
    route
  end

  def route(%Route{method: _, path: "/"}) do
    body = "Pistons, Tigers, RedWings"

    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(body)}

    #{body}
    """
  end

  def route(%Route{method: _, path: _}) do
    """
    HTTP/1.1 404 Not Found
    Content-Type: text/html
    Content-Length: 0

    """
  end
end
