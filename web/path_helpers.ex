defmodule Churchspace.PathHelpers do
  import Churchspace.Router.Helpers

  def path_for_category(conn, route, params \\ []) when is_atom(route) do
    case conn.assigns do
      %{event: event = %Churchspace.Event{}} ->
        event_category_path(conn, route, event, params)
      _ ->
        category_path(conn, route, params)
    end
  end

  def url_for_category(conn, route, params \\ []) when is_atom(route) do
    case conn.assigns do
      %{event: event = %Churchspace.Event{}} ->
        event_category_url(conn, route, event, params)
      _ ->
        category_url(conn, route, params)
    end
  end

  def path_for_post(conn, route, params \\ []) when is_atom(route) do
    case conn.assigns do
      %{event: event = %Churchspace.Event{}} ->
        event_post_path(conn, route, event, params)
      _ ->
        post_path(conn, route, params)
    end
  end

  def url_for_post(conn, route, params \\ []) when is_atom(route) do
    case conn.assigns do
      %{event: event = %Churchspace.Event{}} ->
        event_post_url(conn, route, event, params)
      _ ->
        post_url(conn, route, params)
    end
  end
end
