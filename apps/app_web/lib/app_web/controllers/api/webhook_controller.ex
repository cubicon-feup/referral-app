defmodule AppWeb.WebhookController do
  use AppWeb, :controller

  alias App.Brands
  alias App.Brands.Brand
  alias App.Influencers
  alias App.Influencers.Influencer
  alias App.Contracts
  alias App.Contracts.Contract

  def handleData(conn, params) do
    discount_codes = conn.body_params["discount_codes"]
    value = trunc(String.to_float(conn.body_params["total_price"]))

    case discount_codes do
      nil ->
        send_resp(conn, 200, "no discount codes")

      store ->
        store =
          Plug.Conn.get_req_header(conn, "x-shopify-shop-domain")
          |> List.first()

        assignPromoCodes(store, discount_codes, value)

        send_resp(conn, 200, "ok")
    end
  end

  def assignPromoCodes(store, discount_codes, value) do
    brand = Brands.get_brand_by_hostname(store)[:brand_id]
    influencers = []

    influencers =
      for discount_code <- discount_codes do
        Influencers.get_influencer_by_code(discount_code["code"])[:influencer_id]
      end

    # for influencer <- influencers do
    #   contract = Contracts.get_contract_by_brand_and_influencer(brand, influencer)
    #   new_value = contract[:act_value] + value
    #   Contracts.update_contract()
    # end
  end
end
