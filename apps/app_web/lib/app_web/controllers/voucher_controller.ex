defmodule AppWeb.VoucherController do
  use AppWeb, :controller

  alias App.Vouchers
  alias App.Vouchers.Voucher

  def index(conn, _params) do
    vouchers = Vouchers.list_vouchers()
    render(conn, "index.html", vouchers: vouchers)
  end

  def new(conn, _params) do
    changeset = Vouchers.change_voucher(%Voucher{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"voucher" => voucher_params}) do
    case Vouchers.create_voucher(voucher_params) do
      {:ok, voucher} ->
        conn
        |> put_flash(:info, "Voucher created successfully.")
        |> redirect(to: voucher_path(conn, :show, voucher))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    voucher = Vouchers.get_voucher!(id)
    render(conn, "show.html", voucher: voucher)
  end

  def edit(conn, %{"id" => id}) do
    voucher = Vouchers.get_voucher!(id)
    changeset = Vouchers.change_voucher(voucher)
    render(conn, "edit.html", voucher: voucher, changeset: changeset)
  end

  def update(conn, %{"id" => id, "voucher" => voucher_params}) do
    voucher = Vouchers.get_voucher!(id)

    case Vouchers.update_voucher(voucher, voucher_params) do
      {:ok, voucher} ->
        conn
        |> put_flash(:info, "Voucher updated successfully.")
        |> redirect(to: voucher_path(conn, :show, voucher))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", voucher: voucher, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    voucher = Vouchers.get_voucher!(id)
    {:ok, _voucher} = Vouchers.delete_voucher(voucher)

    conn
    |> put_flash(:info, "Voucher deleted successfully.")
    |> redirect(to: voucher_path(conn, :index))
  end
end
