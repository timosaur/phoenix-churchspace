defmodule Churchspace.PageController do
  use Churchspace.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def manage(conn, _params) do
    render conn, "manage.html"
  end
end
