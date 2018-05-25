defmodule App.Brands do
  @moduledoc """
  The Brands context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Brands.Brand
  alias App.Influencers.Influencer
  alias App.Contracts
  alias App.Contracts.Contract

  @doc """
  Returns the list of brands.

  ## Examples

      iex> list_brands()
      [%Brand{}, ...]

  """
  def list_brands do
    Repo.all(Brand)
  end

  @doc """
  Gets a single brand.

  Raises `Ecto.NoResultsError` if the Brand does not exist.

  ## Examples

      iex> get_brand!(123)
      %Brand{}

      iex> get_brand!(456)
      ** (Ecto.NoResultsError)

  """
  def get_brand!(id) do
    brand = Repo.get!(Brand, id) |> Repo.preload(:contracts)
  end

  def get_brand(id), do: Repo.get(Brand, id)

  def get_brand_by_user(user_id), do: Repo.get_by(Brand, user_id: user_id)

  @doc """
  Gets a all influencers of a brand.

  Raises `Ecto.NoResultsError` if the Brand does not exist.

  ## Examples

      iex> get_brand_influencers!(123)
      %Brand{}???

      iex> get_brand!(456)
      ** (Ecto.NoResultsError)

  """
  def get_brand_contracts(id) do
    query = Contract
    |> where([c], c.brand_id == ^id)

    Repo.all(query)
  end

  @doc """
  Creates a brand.

  ## Examples

      iex> create_brand(%{field: value})
      {:ok, %Brand{}}

      iex> create_brand(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_brand(attrs \\ %{}) do
    %Brand{}
    |> Brand.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a brand.

  ## Examples

      iex> update_brand(brand, %{field: new_value})
      {:ok, %Brand{}}

      iex> update_brand(brand, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_brand(%Brand{} = brand, attrs) do
    brand
    |> Brand.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Brand.

  ## Examples

      iex> delete_brand(brand)
      {:ok, %Brand{}}

      iex> delete_brand(brand)
      {:error, %Ecto.Changeset{}}

  """
  def delete_brand(%Brand{} = brand) do
    Repo.delete(brand)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking brand changes.

  ## Examples

      iex> change_brand(brand)
      %Ecto.Changeset{source: %Brand{}}

  """
  def change_brand(%Brand{} = brand) do
    Brand.changeset(brand, %{})
  end

  def get_brand_id_by_hostname(hostname), do: Repo.get_by(Brand, hostname: hostname)

  def get_total_brand_revenue(brand_id) do
    brand = get_brand!(brand_id)
    contracts = brand.contracts
    revenue = get_value(contracts)
    Decimal.to_integer(revenue)
  end

  def get_number_of_sales(brand_id) do
    brand = get_brand!(brand_id)
    get_contracts_sales(brand.contracts)
  end

  def get_contracts_sales([contract|contracts]) do
    Contracts.get_number_of_sales(contract.id) + get_contracts_sales(contracts)
  end

  def get_contracts_sales([]) do
    0
  end

  def get_brand_total_views(brand_id) do
    brand = get_brand!(brand_id)
    get_contracts_views(brand.contracts)
  end

  def get_contracts_views([contract|contracts]) do
    Contracts.get_total_contract_views(contract.id) + get_contracts_views(contracts)
  end

  def get_contracts_views([]) do
    0
  end

  def get_brand_customers(brand_id) do
    brand = get_brand!(brand_id)
    customers = get_customers_from_contracts(brand.contracts)
  end

  def get_customers_from_contracts([contract|contracts]) do
    custumers = Contracts.get_contract_customers(contract.id) ++ get_customers_from_contracts(contracts)
  end

  def get_customers_from_contracts([]) do
    []
  end


  def get_brand_pending_payments(brand_id) do
    brand = get_brand!(brand_id)
    total = get_contract_pending_payments(brand.contracts)
  end

  def get_contract_pending_payments([contract|contracts]) do
    Contracts.get_contract_pending_payments(contract.id) + get_contract_pending_payments(contracts)
  end

  def get_contract_pending_payments([]) do
    0
  end

  def get_sales_countries(brand_id) do
    brand = get_brand!(brand_id)
    get_sales_countries_from_contracts(brand.contracts)
  end

  def get_sales_countries_from_contracts([contract|contracts]) do
    countries = Contracts.get_sales_countries(contract.id) ++ get_sales_countries_from_contracts(contracts)
  end

  def get_sales_countries_from_contracts([]) do
    []
  end

  def get_brand_vouchers(brand_id) do
    brand = get_brand!(brand_id)
    get_vouchers(brand.contracts)
  end

  def get_vouchers([contract|contracts]) do
    loaded_contract = contract |> Repo.preload(:voucher)
    loaded_contract.voucher ++ get_vouchers(contracts)
  end

  def get_vouchers([]) do
    []
  end

  def get_value([contract|contracts]) do
    a = Decimal.new(Contracts.get_total_contract_revenue(contract.id))
    b = Decimal.new(get_value(contracts))
    Decimal.add(a,b)
  end

  def get_value([]) do
    Decimal.new(0)
  end
end
