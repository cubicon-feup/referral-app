defmodule AppWeb.BrandController do
  require Logger
  use AppWeb, :controller
  import AppWeb.Mailer

  alias App.Contracts
  alias App.Contracts.Contract
  alias App.Brands
  alias App.Brands.Brand

  def index(conn, _params) do
    brands = Brands.list_brands()
    render(conn, "index.html", brands: brands)
  end

  def new(conn, _params) do
    changeset = Brands.change_brand(%Brand{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"brand" => brand_params}) do
    case Brands.create_brand(brand_params) do
      {:ok, brand} ->
        conn
        |> put_flash(:info, "Brand created successfully.")
        |> redirect(to: brand_path(conn, :show, brand))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    brand = Brands.get_brand!(id)
    render(conn, "show.html", brand: brand)
  end

  def edit(conn, %{"id" => id}) do
    brand = Brands.get_brand!(id)
    changeset = Brands.change_brand(brand)
    render(conn, "edit.html", brand: brand, changeset: changeset)
  end

  def update(conn, %{"id" => id, "brand" => brand_params}) do
    brand = Brands.get_brand!(id)

    case Brands.update_brand(brand, brand_params) do
      {:ok, brand} ->
        conn
        |> put_flash(:info, "Brand updated successfully.")
        |> redirect(to: brand_path(conn, :show, brand))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", brand: brand, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    brand = Brands.get_brand!(id)
    {:ok, _brand} = Brands.delete_brand(brand)

    conn
    |> put_flash(:info, "Brand deleted successfully.")
    |> redirect(to: brand_path(conn, :index))
  end

  def invite(conn, %{"id" => id}) do
    #contracts = Brands.list_contracts_brand(id)
    contracts = Contracts.list_contracts()
    brand = Brands.get_brand!(id)
    render(conn, "invite.html", brand: brand, contracts: contracts)
  end

  def send_email(conn, %{"id" => id}) do
    brand = Brands.get_brand!(id)
    Logger.debug "Var value: #{inspect(conn.params["email_form"]["email"])}"
    #send_welcome_email(conn.params["email_form"]["email"])
    render(conn, "show.html", brand: brand)
  end
end
