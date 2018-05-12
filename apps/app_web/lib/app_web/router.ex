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

  pipeline :webhook do
    plug :accepts, ["json"]
    plug App.Auth.Webhook
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
    resources "/user", UserController, only: [:show, :edit, :delete]
    resources "/shorten", LinkController


  end

  scope "/api", AppWeb.Api, as: :api do
    pipe_through [:api, :auth, :ensure_auth]

    post "/shorten/new", LinkController, :create
    post "/shorten/:id/delete", LinkController, :delete

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
    resources "/influencers", InfluencerController
    resources "/agencies", AgencyController
    resources "/plans", PlanController
    resources "/payments", PaymentController
    resources "/sales", SaleController
    resources "/clients", ClientController
    resources "/rules", RuleController
    resources "/account", UserController, only: [:index, :new, :create]
    get "/", PageController, :index
    put "/payments/:id/status" , PaymentController, :update_status
    get "/terms", UserController, :terms
    post "/user/login", UserController, :login
    resources "/contracts", ContractController do
      resources "/vouchers", VoucherController
    end
    get "/404", PageNotFoundController, :show
    get "/brands/:id/new_influencer", BrandController, :new_influencer
    post "/brands/:id/create_influencer", BrandController, :create_influencer
    get "/influencers/:email/:name/invited_new_user", InfluencerController, :invited_new_user
    post "/influencers/:email/:name/invited_create_user", InfluencerController, :invited_create_user
    put "/influencers/:id/invited_update_influencer", InfluencerController, :invited_update_influencer

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
     resources "/shorten", LinkController
  end

  scope "/webhook", AppWeb do
    pipe_through :webhook

    post "/handle", WebhookController, :handleData
  end

  ################################################
  # Fall back 404 Controller #
  ################################################
  scope "/", AppWeb do
    #get "/*path", PageNotFoundController, :error
  end


end
