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
  alias App.Vouchers
  alias App.Vouchers.Voucher

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
    vouchers = []

    vouchers =
      for discount_code <- discount_codes do
        Vouchers.get_voucher_by_code_and_brand_hostname(discount_code["code"], store)
      end
      |> Enum.filter(&(!is_nil(&1)))

    for voucher <- vouchers do
      updateContract(voucher, value)
    end
  end

  def updateContract(voucher, value) do
    contract = Contracts.get_contract!(voucher.contract.id)

    percent_on_sales =
      List.to_float(Decimal.to_string(voucher.percent_on_sales) |> String.to_charlist())

    points_value = List.to_float(Decimal.to_string(contract.points) |> String.to_charlist())

    new_value = points_value + Float.ceil(value * percent_on_sales, 2)

    {:ok, contract} = Contracts.update_contract(contract, %{points: new_value})

    {:ok, sale} =
      Sales.create_sale(%{
        date: DateTime.utc_now(),
        value: value,
        voucher_id: voucher.id
      })
  end
end
