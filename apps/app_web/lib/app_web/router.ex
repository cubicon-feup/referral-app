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
    plug :accepts, ["json"]
  end

  scope "/", AppWeb do
    pipe_through :browser # Use the default browser stack
    resources "/brands", BrandController, except: [:new, :edit]
    resources "/users", UserController
    resources "/influencers", InfluencerController
    resources "/agencies", AgencyController
    resources "/plans", PlanController
    resources "/payments", PaymentController
    resources "/contracts", ContractController
    resources "/vouchers", VoucherController
    resources "/sales", SaleController
    resources "/clients", ClientController
    get "/", PageController, :index
  end

   #Other scopes may use custom stacks.
   scope "/api", AppWeb do
     pipe_through :api
     resources "/brands", BrandController, except: [:new, :edit]
     resources "/users", UserController
     resources "/influencers", InfluencerController
     resources "/agencies", AgencyController
     resources "/plans", PlanController
     resources "/payments", PaymentController
     resources "/contracts", ContractController
     resources "/vouchers", VoucherController
     resources "/sales", SaleController
     resources "/clients", ClientController
   end
end
