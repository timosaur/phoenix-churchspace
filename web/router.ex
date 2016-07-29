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
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/manage", PageController, :manage
  end

  scope "/", Churchspace.Display, as: :view do
    pipe_through :browser

    resources "/events", EventController, only: [:index, :show] do
      get "/index", PostController, :index
      get "/export", EventController, :export, as: :export
      get "/:id", PostController, :show
    end
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
