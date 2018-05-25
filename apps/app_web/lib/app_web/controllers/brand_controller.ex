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

    revenue = 
      case Brands.get_total_brand_revenue(brand_id) do
        nil -> 0
        revenue -> revenue
      end

    sales_count = 
      case Brands.get_number_of_sales(brand_id) do
        nil -> 0
        sales_count -> sales_count
      end

    total_vouchers_views = Brands.get_brand_total_views(brand_id)
    customers = Brands.get_brand_customers(brand_id)
    number_of_customers = Enum.count(Enum.uniq(customers))
    pending_payments = Brands.get_brand_pending_payments(brand_id)
    aov = 
      case sales_count do
        0 -> 0
        sales_count -> div(revenue, sales_count)
      end

    countries = 
      Brands.get_sales_countries(brand_id) |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)|> Enum.sort_by(&(elem(&1, 1)), &>=/2)

    case countries do
      [] ->
        {country1_name, country1_amount} = {"",0}
        {country2_name, country2_amount} = {"",0}
        {country3_name, country3_amount} = {"",0}
      _ ->
        {country1_name, country1_amount} = Enum.at(countries,0)
        {country2_name, country2_amount} = Enum.at(countries,1)
        {country3_name, country3_amount} = Enum.at(countries,2)
    end
    


    render(conn, "index.html", 
      revenue: revenue, 
      sales_count: sales_count, 
      total_vouchers_views: total_vouchers_views, 
      number_of_customers: number_of_customers, 
      aov: aov, 
      pending_payments: pending_payments,
      country1_amount: country1_amount,
      country1_name: country1_name,
      country2_amount: country2_amount,
      country2_name: country2_name,
      country3_amount: country3_amount,
      country3_name: country3_name
    )
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
