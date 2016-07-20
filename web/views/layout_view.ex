defmodule Churchspace.LayoutView do
  use Churchspace.Web, :view

  def js_path(view_module, view_template) do
    [Phoenix.Naming.resource_name(view_module, "View"), view_template]
    |> Enum.join("/")
  end
end
