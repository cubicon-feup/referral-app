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
    send_resp(conn, 200, "ok")

    discount_codes = conn.body_params["discount_codes"]

    value = Decimal.new(conn.body_params["total_price"])

    customer_locale = conn.body_params["billing_address"]["country"]

    total_discounts = String.to_float(conn.body_params["total_discounts"])
    customer_id = conn.body_params["customer"]["default_address"]["customer_id"]
    date = conn.body_params["created_at"]

    case discount_codes do
      nil ->
        send_resp(conn, 404, "no discount codes")

      store ->
        store =
          Plug.Conn.get_req_header(conn, "x-shopify-shop-domain")
          |> List.first()

        assignPromoCodes(
          store,
          discount_codes,
          value,
          customer_locale,
          total_discounts,
          customer_id,
          date
        )
    end
  end

  def assignPromoCodes(
        store,
        discount_codes,
        value,
        customer_locale,
        total_discounts,
        customer_id,
        date
      ) do
    vouchers = []

    vouchers =
      for discount_code <- discount_codes do
        Vouchers.get_voucher_by_code_and_brand_hostname(discount_code["code"], store)
      end
      |> Enum.filter(&(!is_nil(&1)))

    for voucher <- vouchers do
      updateContract(voucher, value, customer_locale, total_discounts, customer_id, date)
    end
  end

  def updateContract(voucher, value, customer_locale, total_discounts, customer_id, date) do
    Vouchers.add_sale(voucher, value)

    sale =
      Ecto.build_assoc(
        voucher,
        :sales,
        date: DateTime.utc_now(),
        value: value,
        customer_locale: customer_locale,
        total_discounts: Decimal.new(total_discounts),
        customer_id: customer_id,
        date_sale: NaiveDateTime.from_iso8601!(date)
      )

    App.Repo.insert!(sale)
  end
end
