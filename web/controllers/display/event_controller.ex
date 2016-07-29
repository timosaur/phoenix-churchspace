defmodule Churchspace.Display.EventController do
  use Churchspace.Web, :controller

  import Phoenix.View, only: [render_to_string: 3]

  alias Churchspace.Display.EventView
  alias Churchspace.Event
  alias Churchspace.Post

  def index(conn, _params) do
    events = Repo.all(Event)
    render(conn, "index.html", events: events)
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    posts = Repo.exec_query(Post.sorted_event_posts(id), Post)
    render(conn, "show.html", event: event, posts: posts)
  end

  def export(conn, %{"event_id" => id}) do
    event = Repo.get!(Event, id)
    posts = Repo.exec_query(Post.sorted_event_full_posts(id), Post)

    {:ok, path} =
      render_to_string(EventView, "export.html", event: event, posts: posts)
      |> PdfGenerator.generate(page_size: "B6") # TODO: move to config
    {:ok, pdf_content} = File.read(path)

    conn
    |> put_resp_content_type("application/pdf")
    |> put_resp_header("Content-Disposition", "attachment; filename=\"#{event.name}.pdf\"")
    |> send_resp(200, pdf_content)
  end
end
