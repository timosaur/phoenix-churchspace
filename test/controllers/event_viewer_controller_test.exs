defmodule Churchspace.EventViewerControllerTest do
  use Churchspace.ConnCase

  alias Churchspace.EventViewer
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, event_viewer_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing events"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, event_viewer_path(conn, :new)
    assert html_response(conn, 200) =~ "New event viewer"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, event_viewer_path(conn, :create), event_viewer: @valid_attrs
    assert redirected_to(conn) == event_viewer_path(conn, :index)
    assert Repo.get_by(EventViewer, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, event_viewer_path(conn, :create), event_viewer: @invalid_attrs
    assert html_response(conn, 200) =~ "New event viewer"
  end

  test "shows chosen resource", %{conn: conn} do
    event_viewer = Repo.insert! %EventViewer{}
    conn = get conn, event_viewer_path(conn, :show, event_viewer)
    assert html_response(conn, 200) =~ "Show event viewer"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, event_viewer_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    event_viewer = Repo.insert! %EventViewer{}
    conn = get conn, event_viewer_path(conn, :edit, event_viewer)
    assert html_response(conn, 200) =~ "Edit event viewer"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    event_viewer = Repo.insert! %EventViewer{}
    conn = put conn, event_viewer_path(conn, :update, event_viewer), event_viewer: @valid_attrs
    assert redirected_to(conn) == event_viewer_path(conn, :show, event_viewer)
    assert Repo.get_by(EventViewer, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    event_viewer = Repo.insert! %EventViewer{}
    conn = put conn, event_viewer_path(conn, :update, event_viewer), event_viewer: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit event viewer"
  end

  test "deletes chosen resource", %{conn: conn} do
    event_viewer = Repo.insert! %EventViewer{}
    conn = delete conn, event_viewer_path(conn, :delete, event_viewer)
    assert redirected_to(conn) == event_viewer_path(conn, :index)
    refute Repo.get(EventViewer, event_viewer.id)
  end
end
