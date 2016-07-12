defmodule Churchspace.PostViewerController do
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

  defp load_sibling_posts(conn, _) do
  end

  defp event_posts(nil), do: Post
  defp event_posts(%Event{} = event), do: assoc(event, :posts)

  def index(conn, _params) do
    # TODO: filter by parent nil
    posts = Repo.all(event_posts(conn.assigns[:event]))
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    top_level_posts =
      event_posts(conn.assigns[:event])
      |> Post.for_parent(nil)
      |> Repo.all()
    sibling_posts =
      case post.parent_id do
        nil ->
          []
        _ ->
          event_posts(conn.assigns[:event])
          |> Post.for_parent(post.parent_id)
          |> Repo.all()
      end
    child_posts =
      event_posts(conn.assigns[:event])
      |> Post.for_parent(post.id)
      |> Repo.all()

    render(conn, "show.html", post: post, siblings: sibling_posts,
                              top_level_posts: top_level_posts, children: child_posts)
  end
end
