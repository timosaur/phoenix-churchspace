defmodule Churchspace.DisplayView do
  use Churchspace.Web, :view

  @default_name "contents"
  @default_list_class "list-group-item"

  def construct_posts_sidebar(conn, posts, opts \\ []) do
    create_nested_list_group(conn, nest_by_depth(posts), opts)
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

  def create_nested_list_group(conn, posts, opts \\ []) do
    for item <- posts do
      case item do
        %{data: post, children: []} ->
          list_elem(conn, post, opts)
        %{data: post, children: children} ->
          child_elems = create_nested_list_group(conn, children, opts)
          sublist_elem(conn, post, child_elems, opts)
      end
    end
  end

  defp list_elem(conn, post, opts \\ [])

  defp list_elem(%{assigns: %{post: %{id: page_id}}} = conn, %{id: id} = post, opts)
  when id == page_id do
    class = Keyword.get(opts, :list_class, @default_list_class)
    link post.title,
         to: view_event_post_path(conn, :show, conn.assigns[:event], post),
         class: "#{class} active"
  end

  defp list_elem(conn, post, opts) do
    class = Keyword.get(opts, :list_class, @default_list_class)
    link post.title,
         to: view_event_post_path(conn, :show, conn.assigns[:event], post),
         class: "#{class}"
  end

  defp sublist_elem(_conn, post, child_elems, opts \\ []) do
    name = Keyword.get(opts, :name, @default_name)
    shown = if Keyword.get(opts, :expanded), do: "in", else: ""
    sublist =
      content_tag :div, id: "#{name}-#{post.id}", class: "collapse #{shown}" do
        child_elems
      end
    [toggle_elem(post.id, post.title, opts), sublist]
  end

  defp toggle_elem(id, text, opts \\ []) do
    name = Keyword.get(opts, :name, @default_name)
    class = Keyword.get(opts, :list_class, @default_list_class)
    link to: "##{name}-#{id}",
         class: "#{class}",
         "data-toggle": "collapse" do
      caret = tag :span, class: "caret"
      [text, caret]
    end
  end
end
