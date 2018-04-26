defmodule AppWeb.WebhookController do
  use AppWeb, :controller

  alias App.Brands
  alias App.Brands.Brand
  alias App.Influencers
  alias App.Influencers.Influencer

  def handleData(conn, params) do
    discount_codes = conn.body_params["discount_codes"]

    case discount_codes do
      nil ->
        send_resp(conn, 200, "no discount codes")

      store ->
        store =
          Plug.Conn.get_req_header(conn, "x-shopify-shop-domain")
          |> List.first()

        assignPromoCodes(store, discount_codes)

        send_resp(conn, 200, "ok")
    end
  end

  def assignPromoCodes(store, discount_codes) do
    brand = Brands.get_brand_by_hostname(store)[:brand_id]
    codes = []

    codes =
      for discount_code <- discount_codes do
        Influencers.get_influencer_by_code(discount_code["code"])[:influencer_id]
      end

    IO.inspect(brand)
    IO.inspect(codes)
  end
end
