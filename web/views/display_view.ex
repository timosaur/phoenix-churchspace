defmodule Churchspace.DisplayView do
  use Churchspace.Web, :view

  @elem_name "contents"
  @parent_id "##{@elem_name}"

  def construct_posts_sidebar(conn, posts) do
    create_nested_list_group(conn, nest_by_depth(posts))
  end

  def nest_by_depth(items) do
    case do_nest_by_depth(items) do
      {results, []} ->
        results
      _ ->
        []
    end
  end

  defp do_nest_by_depth([]) do
    {[], []}
  end

  defp do_nest_by_depth([first]) do
    {[nest_item(first)], []}
  end

  defp do_nest_by_depth([%{depth: d} = first | [%{depth: next_d} | _] = rest])
  when next_d < d do
    {[nest_item(first)], rest}
  end

  defp do_nest_by_depth([%{depth: d} = first | [%{depth: next_d} | _] = rest])
  when next_d == d do
    {siblings, remaining} = do_nest_by_depth(rest)
    {[nest_item(first) | siblings], remaining}
  end

  defp do_nest_by_depth([%{depth: d} = first | [%{depth: next_d} | _] = rest])
  when next_d > d do
    {children, remaining} = do_nest_by_depth(rest)
    {siblings, remaining} = do_nest_by_depth(remaining)
    {nest_item_with_children(first, children) ++ siblings, remaining}
  end

  defp nest_item(post) do
    %{data: post, children: []}
  end

  defp nest_item_with_children(post, children) do
    [%{data: post, children: children}]
  end

  def create_nested_list_group(conn, posts) do
    for item <- posts do
      case item do
        %{data: post, children: []} ->
          list_elem(conn, post)
        %{data: post, children: children} ->
          child_elems = create_nested_list_group(conn, children)
          sublist_elem(conn, post, child_elems)
      end
    end
  end

  defp list_elem(%{assigns: %{post: %{id: page_id}}} = conn, %{id: id} = post)
  when id == page_id do
    link post.title,
         to: view_event_post_path(conn, :show, conn.assigns[:event], post),
         class: "list-group-item active",
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
    link to: "##{@elem_name}-#{id}",
         class: "list-group-item",
         "data-toggle": "collapse",
         "data-parent": @parent_id do
      caret = tag :span, class: "caret"
      [text, caret]
    end
  end
end
