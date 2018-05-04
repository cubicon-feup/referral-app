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
    brand_id = Brands.get_brand_id_by_hostname(store)[:brand_id]
    influencers_id = []

    influencers_id =
      for discount_code <- discount_codes do
        Influencers.get_influencer_id_by_code(discount_code["code"])[:influencer_id]
      end

    for influencer_id <- influencers_id do
      percentage = 0.1
      updateContract(influencer_id, brand_id, value, percentage)
    end
  end

  def updateContract(influencer_id, brand_id, value, percentage) do
    contract = Contracts.get_contract_by_brand_and_influencer(brand_id, influencer_id)
    new_value = contract.points + trunc(value * percentage)

    {:ok, contract} = Contracts.update_contract(contract, %{points: new_value})

    {:ok, sale} =
      Sales.create_sale(%{
        date: DateTime.utc_now(),
        value: value,
        contract_id: contract.id
      })
  end
end
