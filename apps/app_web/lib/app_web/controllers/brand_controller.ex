defmodule AppWeb.BrandController do
  use AppWeb, :controller

  alias App.Repo

  alias App.Brands
  alias App.Brands.Brand

  alias App.Contracts
  alias App.Contracts.Contract

  import AppWeb.Mailer

  def index(conn, _params) do

    brand_id = get_session(conn, :brand_id)
    brand = Brands.get_brand!(brand_id)

    revenue = Brands.get_total_brand_revenue(brand_id)
    sales_count = Brands.get_number_of_sales(brand_id)
    total_vouchers_views = Brands.get_brand_total_views(brand_id)

    costumers = []
    for contract <- brand.contracts do
      loaded_contract = contract |> Repo.preload(:voucher)
      for voucher <- loaded_contract.voucher do
        loaded_voucher = voucher |> Repo.preload(:sales)
        for sale <- loaded_voucher.sales do
          costumers ++ [sale.customer_id]
        end
      end
    end
    IO.inspect(costumers, label: ":::::::::::::")

    render(conn, "index.html", revenue: revenue, sales_count: sales_count, total_vouchers_views: total_vouchers_views)
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
