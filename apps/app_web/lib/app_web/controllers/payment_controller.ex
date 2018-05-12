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
    influencers = Brands.get_brand_influencers(1)
    influencers = Enum.map(influencers, fn influencer -> 
      contract = Contracts.get_contract_by_brand_and_influencer(brand_id, influencer.id)
      influencer
      |> Map.put(:payment_period, contract.payment_period)
    end)
    changeset = Payments.change_payment(%Payment{})
    render(conn, "new.html", changeset: changeset, influencers: influencers)
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
        influencers = Brands.get_brand_influencers(1)
        influencers = Enum.map(influencers, fn influencer -> 
          contract = Contracts.get_contract_by_brand_and_influencer(brand_id, influencer.id)
          influencer
          |> Map.put(:payment_period, contract.payment_period)
        end)
        render(conn, "new.html", changeset: changeset, influencers: influencers)
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
        render(conn, "edit.html", payment: payment, changeset: changeset, influencers: Brands.get_brand_influencers(1))
    end
  end

  def update_status(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Payments.get_payment!(id)
    case Payments.update_payment(payment, payment_params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment updated successfully.")
        |> halt
        |> send_resp(201, "")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", payment: payment, changeset: changeset, influencers: Brands.get_brand_influencers(1))
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
