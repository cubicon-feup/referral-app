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

    get "/", PageController, :index
  end

   #Other scopes may use custom stacks.
   scope "/api", AppWeb do
     pipe_through :api
     resources "/brands", BrandController, except: [:new, :edit]
     resources "/agencies", AgencyController, except: [:new, :edit]
     resources "/payments", PaymentController, except: [:new, :edit]
     resources "/payment_voucher", Payment_voucherController, except: [:new, :edit]
     resources "/plan", PlanController, except: [:new, :edit]
     resources "/influencers", InfluencerController, except: [:new, :edit]
     resources "/contracts", ContractController, except: [:new, :edit]
     resources "/vouchers", VoucherController, except: [:new, :edit]
     resources "/sales", SaleController, except: [:new, :edit]
     resources "/clients", ClientController, except: [:new, :edit]
     resources "/user", UserController
   end
end
