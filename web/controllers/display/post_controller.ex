defmodule Churchspace.Display.PostController do
  use Churchspace.Web, :controller

  alias Churchspace.Event
  alias Churchspace.Post

  plug :load_posts

  defp load_posts(conn, _) do
    posts =
      conn.params["event_id"]
      |> Post.sorted_event_posts()
      |> Repo.exec_query(Post)
    assign(conn, :posts, posts)
  end

  def action(conn, _) do
    conn =
      case conn.params do
        %{"event_id" => id} ->
          assign(conn, :event, Repo.get!(Event, id))
        _ ->
          assign(conn, :event, nil)
      end
    apply(__MODULE__, action_name(conn), [conn, conn.params])
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    render(conn, "show.html", post: post)
  end
end
