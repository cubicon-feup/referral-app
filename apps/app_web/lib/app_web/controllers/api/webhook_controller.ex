defmodule AppWeb.WebhookController do
  use AppWeb, :controller

  alias App.Brands
  alias App.Brands.Brand
  alias App.Influencers
  alias App.Influencers.Influencer
  alias App.Contracts
  alias App.Contracts.Contract
  alias App.Sales
  alias App.Sales.Sale

  def handleData(conn, params) do
    discount_codes = conn.body_params["discount_codes"]
    value = String.to_float(conn.body_params["total_price"])

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

    for influencer <- influencers do
      percentage = 0.1
      updateContract(influencer, brand, value, percentage)
    end
  end

  def updateContract(influencer, brand, value, percentage) do
    contract = Contracts.get_contract_by_brand_and_influencer(brand, influencer)

    c = Contracts.get_contract!(contract[:contract_id])
    new_value = contract[:act_value] + trunc(value * percentage)

    {:ok, c} = Contracts.update_contract(c, %{points: new_value})

    {:ok, sale} =
      Sales.create_sale(%{
        date: DateTime.utc_now(),
        value: value,
        contract_id: contract[:contract_id]
      })
  end
end
