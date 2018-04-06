defmodule AppWeb.Payment_voucherController do
  use AppWeb, :controller

  alias App.Payment_vouchers
  alias App.Payment_vouchers.Payment_voucher

  action_fallback AppWeb.FallbackController

  def index(conn, _params) do
    payment_voucher = Payment_vouchers.list_payment_voucher()
    render(conn, "index.json", payment_voucher: payment_voucher)
  end

  def create(conn, %{"payment_voucher" => payment_voucher_params}) do
    with {:ok, %Payment_voucher{} = payment_voucher} <- Payment_vouchers.create_payment_voucher(payment_voucher_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", payment_voucher_path(conn, :show, payment_voucher))
      |> render("show.json", payment_voucher: payment_voucher)
    end
  end

  def show(conn, %{"id" => id}) do
    payment_voucher = Payment_vouchers.get_payment_voucher!(id)
    render(conn, "show.json", payment_voucher: payment_voucher)
  end

  def update(conn, %{"id" => id, "payment_voucher" => payment_voucher_params}) do
    payment_voucher = Payment_vouchers.get_payment_voucher!(id)

    with {:ok, %Payment_voucher{} = payment_voucher} <- Payment_vouchers.update_payment_voucher(payment_voucher, payment_voucher_params) do
      render(conn, "show.json", payment_voucher: payment_voucher)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment_voucher = Payment_vouchers.get_payment_voucher!(id)
    with {:ok, %Payment_voucher{}} <- Payment_vouchers.delete_payment_voucher(payment_voucher) do
      send_resp(conn, :no_content, "")
    end
  end
end
