defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AppWeb.SaveLocale
  end

  pipeline :api do
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug App.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__
  end

  pipeline :public do
    plug :accepts, ["html"]
  end

  #########################################
  # Endpoints that require authentication #
  #########################################
  scope "/", AppWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/user/logout", UserController, :logout # temporary route for testing purposes
    post "/user/logout", UserController, :logout
    resources "/shorten", LinkController


  end

  scope "/api", AppWeb.Api, as: :api do
     pipe_through [:api, :auth, :ensure_auth]


  end

  ################################################
  #            Shorten url endpoint              #
  ################################################

  scope "/promo", AppWeb do
    pipe_through :public
    get "/:shortcode", LinkController, :unshorten
  end

  ################################################
  # Endpoints that do not require authentication #
  ################################################

  scope "/", AppWeb do
    pipe_through [:browser, :auth]

    resources "/brands", BrandController
    resources "/users", UserController
    resources "/influencers", InfluencerController
    resources "/agencies", AgencyController
    resources "/plans", PlanController
    resources "/payments", PaymentController
    resources "/sales", SaleController
    resources "/clients", ClientController
    resources "/rules", RuleController
    resources "/contracts", ContractController do
      resources "/vouchers", VoucherController       
    end
    get "/", PageController, :index
    post "/payments/:id" , PaymentController, :update_status
    resources "/user", UserController, only: [:index, :new, :create, :show]
    post "/user/login", UserController, :login
    get "/404", PageNotFoundController, :show

  end

  scope "/api", AppWeb.Api, as: :api do
     pipe_through [:api, :auth]

     resources "/brands", BrandController
     resources "/users", UserController
     resources "/influencers", InfluencerController
     resources "/agencies", AgencyController
     resources "/plans", PlanController
     resources "/payments", PaymentController
     resources "/rules", RuleController
     resources "/contracts", ContractController
     resources "/vouchers", VoucherController
     resources "/sales", SaleController
     resources "/clients", ClientController
  end

  ################################################
  # Fall back 404 Controller #
  ################################################
  scope "/", AppWeb do
    get "/*path", PageNotFoundController, :error
  end


end
