defmodule Churchspace.PostViewerControllerTest do
  use Churchspace.ConnCase

  alias Churchspace.PostViewer
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_viewer_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing posts"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, post_viewer_path(conn, :new)
    assert html_response(conn, 200) =~ "New post viewer"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, post_viewer_path(conn, :create), post_viewer: @valid_attrs
    assert redirected_to(conn) == post_viewer_path(conn, :index)
    assert Repo.get_by(PostViewer, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_viewer_path(conn, :create), post_viewer: @invalid_attrs
    assert html_response(conn, 200) =~ "New post viewer"
  end

  test "shows chosen resource", %{conn: conn} do
    post_viewer = Repo.insert! %PostViewer{}
    conn = get conn, post_viewer_path(conn, :show, post_viewer)
    assert html_response(conn, 200) =~ "Show post viewer"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_viewer_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    post_viewer = Repo.insert! %PostViewer{}
    conn = get conn, post_viewer_path(conn, :edit, post_viewer)
    assert html_response(conn, 200) =~ "Edit post viewer"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    post_viewer = Repo.insert! %PostViewer{}
    conn = put conn, post_viewer_path(conn, :update, post_viewer), post_viewer: @valid_attrs
    assert redirected_to(conn) == post_viewer_path(conn, :show, post_viewer)
    assert Repo.get_by(PostViewer, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post_viewer = Repo.insert! %PostViewer{}
    conn = put conn, post_viewer_path(conn, :update, post_viewer), post_viewer: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit post viewer"
  end

  test "deletes chosen resource", %{conn: conn} do
    post_viewer = Repo.insert! %PostViewer{}
    conn = delete conn, post_viewer_path(conn, :delete, post_viewer)
    assert redirected_to(conn) == post_viewer_path(conn, :index)
    refute Repo.get(PostViewer, post_viewer.id)
  end
end
