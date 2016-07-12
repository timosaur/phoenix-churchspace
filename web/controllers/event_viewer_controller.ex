defmodule Churchspace.EventViewerController do
  use Churchspace.Web, :controller

  alias Churchspace.Event
  alias Churchspace.Post

  def index(conn, _params) do
    events = Repo.all(Event)
    render(conn, "index.html", events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    posts =
      event
      |> assoc(:posts)
      |> Repo.all()
    render(conn, "show.html", event: event, posts: posts)
  end
end
