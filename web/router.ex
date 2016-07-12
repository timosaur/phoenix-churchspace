defmodule Churchspace.Router do
  use Churchspace.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Churchspace do
    pipe_through :browser

    get "/", PageController, :index
    get "/e/:event_id/:id/", PostViewerController, :show
    get "/e/:event_id/index/", PostViewerController, :index
    resources "/e", EventViewerController, only: [:index, :show]
  end

  scope "/manage", Churchspace do
    pipe_through :browser

    resources "/posts", PostController
    resources "/events", EventController do
      # For event posts.
      resources "/posts", PostController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Churchspace do
  #   pipe_through :api
  # end
end
