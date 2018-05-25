defmodule AppWeb.PaymentController do
  use AppWeb, :controller

  alias App.Payments
  alias App.Payments.Payment
  alias App.Brands
  alias App.Contracts

  def index(conn, _params) do
    payments = Payments.list_payments()
    render(conn, "index.html", payments: payments)
  end

  def new(conn, _params) do
    brand_id = Plug.Conn.get_session(conn, :brand_id)
    contracts = Brands.get_brand_contracts(brand_id)

    changeset = Payments.change_payment(%Payment{})
    render(conn, "new.html", changeset: changeset, contracts: contracts)
  end

  def create(conn, %{"payment" => payment_params}) do
    {:ok, deadline} = NaiveDateTime.from_iso8601(payment_params["deadline_date"] <> "T23:59:59Z")
    params = Enum.into(%{"deadline_date" => deadline}, payment_params)

    if !Map.has_key?(payment_params, "brand_id") do
      brand_id = Plug.Conn.get_session(conn, :brand_id)
      params = Enum.into(%{"brand_id" => brand_id}, params)
    end

    
    case Payments.create_payment(params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment created successfully.")
        |> redirect(to: payment_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        brand_id = Plug.Conn.get_session(conn, :brand_id)
        contracts = Brands.get_brand_contracts(brand_id)
        render(conn, "new.html", changeset: changeset, contracts: contracts)
      {:error_no_points, %Ecto.Changeset{} = changeset} ->
        brand_id = Plug.Conn.get_session(conn, :brand_id)
        contracts = Brands.get_brand_contracts(brand_id)
        conn
        |> put_flash(:error, "No Points")
        |> render("new.html", changeset: changeset, contracts: contracts)

    end
  end

  def show(conn, %{"id" => id}) do
    payment = Payments.get_payment!(id)
    render(conn, "show.html", payment: payment)
  end

  def edit(conn, %{"id" => id}) do
    contracts = Brands.get_brand_contracts(1)
    payment = Payments.get_payment!(id)
    changeset = Payments.change_payment(payment)
    render(conn, "edit.html", payment: payment, changeset: changeset, contracts: contracts)
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Payments.get_payment!(id)
    case Payments.update_payment(payment, payment_params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment updated successfully.")
        |> redirect(to: payment_path(conn, :show, payment))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", payment: payment, changeset: changeset, contracts: Brands.get_brand_contracts(1))
    end
  end

  def update_status(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Payments.get_payment!(id)
    
    case payment_params["status"] do
      "complete" ->
        action = Payments.complete_payment(payment)
      "cancelled" ->
        action = Payments.cancel_payment(payment)
    end

    case action do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment updated successfully.")
        |> halt
        |> send_resp(201, "")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", payment: payment, changeset: changeset, contracts: Brands.get_brand_contracts(1))
    end
  end
  
  def delete(conn, %{"id" => id}) do
    payment = Payments.get_payment!(id)
    {:ok, _payment} = Payments.delete_payment(payment)

    conn
    |> put_flash(:info, "Payment deleted successfully.")
    |> redirect(to: payment_path(conn, :index))
  end
end
