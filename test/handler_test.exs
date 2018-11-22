defmodule Servy.HandlerTest do
  use ExUnit.Case

  test "Responds with Detroits Sports teams" do
    request = """
GET / HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
    expected_response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 25

Pistons, Tigers, RedWings
"""

    assert Servy.Handler.handle(request) == expected_response
  end

end
