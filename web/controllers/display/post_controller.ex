defmodule Churchspace.Display.PostController do
  use Churchspace.Web, :controller

  alias Churchspace.Event
  alias Churchspace.Post

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

  defp event_posts(nil), do: Post |> Post.for_event(nil)
  defp event_posts(%Event{} = event), do: assoc(event, :posts)

  def index(conn, _params) do
    posts =
      Post.sorted_event_posts(conn.assigns[:event])
      |> Repo.exec_query(Post)
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    render(conn, "show.html", post: post)
  end
end
