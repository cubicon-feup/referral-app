defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Cocu.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__
  end

  scope "/", AppWeb do
    pipe_through [:browser, :auth] # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    
  end

  scope "/api", AppWeb.Api, as: :api do
    pipe_through [:api, :auth, :ensure_auth]

    resources "/users", UserController

  end

  #########################################
  # Endpoints that require authentication #
  #########################################
  
  scope "/", AppWeb do
    pipe_through [:browser, :auth, :ensure_auth] # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    
  end

  scope "/api", AppWeb.Api, as: :api do
    pipe_through [:api, :auth, :ensure_auth]

    resources "/users", UserController

  end

  scope "/", CocuWeb do
    get "/*path", PageNotFoundController, :error
  end

end
