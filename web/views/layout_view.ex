defmodule Churchspace.LayoutView do
  use Churchspace.Web, :view

  def js_path(view_module, view_template) do
    [Phoenix.Naming.resource_name(view_module, "View"), view_template]
    |> Enum.join("/")
  end

  def page_title(conn, default \\ "Churchspace") do
    case Map.get(conn.assigns, :post) do
      nil ->
        conn.assigns
        |> Map.get(:event, %{})
        |> Map.get(:name, default)
      post ->
        post.title
    end
  end
end
