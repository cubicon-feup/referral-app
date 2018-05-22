defmodule AppWeb.BrandController do
  use AppWeb, :controller

  alias App.Brands
  alias App.Brands.Brand

  alias App.Contracts
  alias App.Contracts.Contract

  import AppWeb.Mailer

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

  def new_contract(conn, %{"id" => id}) do
    brand = Brands.get_brand!(id)
    changeset = Contracts.change_contract(%Contract{brand_id: id})
    render(conn, "new_contract.html", brand: brand, changeset: changeset)
  end

  def create_contract(conn, %{"id" => id, "contract" => contract_params}) do
    brand_id = Plug.Conn.get_session(conn, :brand_id)
    brand = Brands.get_brand!(brand_id)
    
    contract_params = Map.put(contract_params, "brand_id", brand_id)

    case Contracts.get_contract_by_email!(Map.get(contract_params, "email")) do
      nil->
        case Contracts.create_contract(contract_params) do
          {:ok, contract} ->
            conn
            |> put_flash(:info, "Contract created successfully.")
            |> redirect(to: brand_path(conn, :show, id))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new_contract.html", brand: brand, changeset: changeset)
        end
      contract->
        conn
        |> put_flash(:info, "Contract already added.")
        |> redirect(to: brand_path(conn, :show, id))
    end
  end
end
