defmodule Churchspace.DisplayView do
  use Churchspace.Web, :view

  @elem_name "contents"
  @parent_id "##{@elem_name}"

  def construct_posts_sidebar(conn, posts) do
    case sidebar_elems(conn, posts) do
      {elems, []} ->
        elems
      _ ->
        []
    end
  end

  defp sidebar_elems(_conn, []) do
    {[], []}
  end

  defp sidebar_elems(conn, [first]) do
    {[list_elem(conn, first)], []}
  end

  defp sidebar_elems(conn, [%{depth: d} = first | [%{depth: next_d} | _] = rest])
  when next_d < d do
    {[list_elem(conn, first)], rest}
  end

  defp sidebar_elems(conn, [%{depth: d} = first | [%{depth: next_d} | _] = rest])
  when next_d == d do
    {siblings, remaining} = sidebar_elems(conn, rest)
    {[list_elem(conn, first) | siblings], remaining}
  end

  defp sidebar_elems(conn, [%{depth: d} = first | [%{depth: next_d} | _] = rest])
  when next_d > d do
    {children, remaining} = sidebar_elems(conn, rest)
    {siblings, remaining} = sidebar_elems(conn, remaining)
    {sublist_elem(conn, first, children) ++ siblings, remaining}
  end

  defp list_elem(%{assigns: %{post: %{id: page_id}}} = conn, %{id: id} = post)
  when id == page_id do
    link post.title,
         to: view_event_post_path(conn, :show, conn.assigns[:event], post),
         class: "list-group-item list-group-item-info",
         "data-parent": @parent_id
  end

  defp list_elem(conn, post) do
    link post.title,
         to: view_event_post_path(conn, :show, conn.assigns[:event], post),
         class: "list-group-item",
         "data-parent": @parent_id
  end

  defp sublist_elem(_conn, post, child_elems) do
    sublist =
      content_tag :div, id: "#{@elem_name}-#{post.id}", class: "collapse" do
        child_elems
      end
    [toggle_elem(post.id, post.title), sublist]
  end

  defp toggle_elem(id, text) do
    link text,
         to: "##{@elem_name}-#{id}",
         class: "list-group-item",
         "data-toggle": "collapse",
         "data-parent": @parent_id
  end
end
