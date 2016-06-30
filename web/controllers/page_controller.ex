defmodule Churchspace.PageController do
  use Churchspace.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
