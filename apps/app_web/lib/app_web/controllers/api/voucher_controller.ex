defmodule AppWeb.Api.VoucherController do
  use AppWeb, :controller

  alias App.Vouchers
  alias App.Vouchers.Voucher
  alias App.Brands

  action_fallback(AppWeb.FallbackController)

  def index(conn, _params) do
    vouchers = Vouchers.list_vouchers()
    render(conn, "index.json", vouchers: vouchers)
  end

  def create(conn, %{"voucher" => voucher_params}) do
    with {:ok, %Voucher{} = voucher} <- Vouchers.create_voucher(voucher_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_voucher_path(conn, :show, voucher))
      |> render("show.json", voucher: voucher)
    end
  end

  def show(conn, %{"id" => id}) do
    voucher = Vouchers.get_voucher!(id)
    render(conn, "show.json", voucher: voucher)
  end

  def update(conn, %{"id" => id, "voucher" => voucher_params}) do
    voucher = Vouchers.get_voucher!(id)

    with {:ok, %Voucher{} = voucher} <- Vouchers.update_voucher(voucher, voucher_params) do
      render(conn, "show.json", voucher: voucher)
    end
  end

  def delete(conn, %{"id" => id}) do
    voucher = Vouchers.get_voucher!(id)

    with {:ok, %Voucher{}} <- Vouchers.delete_voucher(voucher) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_price_rule(conn, %{"brand_id" => brand_id, "price_rule_id" => price_rule_id}) do
    url = build_url(brand_id) <> "/admin/price_rules/" <> price_rule_id <> ".json"

    price_rule =
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          parse =
            Poison.Parser.parse!(body)
            |> get_in(["price_rule"])

        {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
          json(conn, %{message: "Price rule not found"})
      end

    json(conn, %{price_rule: price_rule})
  end

  def build_url(brand_id) do
    brand = Brands.get_brand!(brand_id)

    base_url = "https://" <> brand.api_key <> ":" <> brand.api_password <> "@" <> brand.hostname
  end
end
