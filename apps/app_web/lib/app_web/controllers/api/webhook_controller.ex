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

    IO.inspect(vouchers, label: "voucher")

    for voucher <- vouchers do
      updateContract(voucher, value)
    end
  end

  def updateContract(voucher, value) do
    contract = voucher.contract

    percent_on_sales =
      List.to_float(Decimal.to_string(voucher.percent_on_sales) |> String.to_charlist())

    points_value = List.to_float(Decimal.to_string(contract.points) |> String.to_charlist())

    new_value = points_value + trunc(value * percent_on_sales)

    {:ok, contract} = Contracts.update_contract(contract, %{points: new_value})

    voucher_map =
      struct_to_map(voucher)
      |> IO.inspect()

    {:ok, sale} =
      Sales.create_sale(%{
        date: DateTime.utc_now(),
        value: value,
        voucher: voucher_map
      })
  end

  def struct_to_map(voucher) do
    voucher_map = Map.from_struct(voucher)
    # contract_map = Map.from_struct(voucher.contract)
    # brand_map = Map.from_struct(voucher.contract.brand)
    # influencer_map = Map.from_struct(voucher.contract.influencer)

    # contract_map = Map.delete(contract_map, :brand)
    # contract_map = Map.put(contract_map, :brand, brand_map)

    # contract_map = Map.delete(contract_map, :influencer)
    # contract_map = Map.put(contract_map, :influencer, influencer_map)

    Map.delete(voucher_map, :contract)
    # Map.put(voucher_map, :contract, contract_map)
  end
end
