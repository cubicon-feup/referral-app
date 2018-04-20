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

    resources "/brands", BrandController
    resources "/user", UserController
    resources "/influencers", InfluencerController
    resources "/agencies", AgencyController
    resources "/plans", PlanController
    resources "/payments", PaymentController
    resources "/contracts", ContractController do
      resources "/vouchers", VoucherController       
    end
    resources "/sales", SaleController
    resources "/clients", ClientController
    get "/", PageController, :index
    get "/brands/:id/invite", BrandController, :invite
    post "/brands/:id/send_email", BrandController, :send_email
  end


   #Other scopes may use custom stacks.
   scope "/api", AppWeb.Api, as: :api do
     pipe_through :api
     resources "/brands", BrandController
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
