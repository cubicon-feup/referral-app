defmodule AppWeb.PaymentController do
  use AppWeb, :controller

  alias App.Payments
  alias App.Payments.Payment
  alias App.Brands
  alias App.Influencers

  def index(conn, _params) do
    payments = Payments.list_payments()
    render(conn, "index.html", payments: payments)
  end

  def new(conn, _params) do
    influencers = Brands.get_brand_influencers(1)
    changeset = Payments.change_payment(%Payment{})
    render(conn, "new.html", changeset: changeset, influencers: influencers)
  end

  def create(conn, %{"payment" => payment_params}) do
    case Payments.create_payment(payment_params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment created successfully.")
        |> redirect(to: payment_path(conn, :show, payment))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    payment = Payments.get_payment!(id)
    render(conn, "show.html", payment: payment)
  end

  def edit(conn, %{"id" => id}) do
    influencers = Brands.get_brand_influencers(1)
    payment = Payments.get_payment!(id)
    changeset = Payments.change_payment(payment)
    render(conn, "edit.html", payment: payment, changeset: changeset, influencers: influencers)
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Payments.get_payment!(id)

    case Payments.update_payment(payment, payment_params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment updated successfully.")
        |> redirect(to: payment_path(conn, :show, payment))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", payment: payment, changeset: changeset)
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
