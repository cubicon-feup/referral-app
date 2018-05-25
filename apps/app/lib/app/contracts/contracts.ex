defmodule App.Contracts do
  @moduledoc """
  The Contracts context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Contracts.Contract
  alias App.Vouchers

  @doc """
  Returns the list of contracts.

  ## Examples

      iex> list_contracts()
      [%Contract{}, ...]

  """
  def list_contracts do
    Repo.all(Contract)
  end

  @doc """
  Gets a single contract.

  Raises `Ecto.NoResultsError` if the Contract does not exist.

  ## Examples

      iex> get_contract!(123)
      %Contract{}

      iex> get_contract!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contract!(id) do
    contract =
      Repo.get!(Contract, id)
      |> Repo.preload(:voucher)
      |> Repo.preload(:brand)
  end

  @doc """
  Creates a contract.

  ## Examples

      iex> create_contract(%{field: value})
      {:ok, %Contract{}}

      iex> create_contract(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contract(attrs \\ %{}) do
    %Contract{}
    |> Contract.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contract.

  ## Examples

      iex> update_contract(contract, %{field: new_value})
      {:ok, %Contract{}}

      iex> update_contract(contract, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contract(%Contract{} = contract, attrs) do
    contract
    |> Contract.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Contract.

  ## Examples

      iex> delete_contract(contract)
      {:ok, %Contract{}}

      iex> delete_contract(contract)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contract(%Contract{} = contract) do
    Repo.delete(contract)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contract changes.

  ## Examples

      iex> change_contract(contract)
      %Ecto.Changeset{source: %Contract{}}

  """
  def change_contract(%Contract{} = contract) do
    Contract.changeset(contract, %{})
  end

  def get_contract_by_email!(email) do
    Repo.get_by(Contract, email: email)
  end

  def get_contract_by_brand(brand_id),
    do: Repo.get_by(Contract, brand_id: brand_id)

  def add_points(%Contract{} = contract, add) do
    new_points = Decimal.to_float(contract.points) + add
    update_contract(contract, %{points: new_points})
  end

  def add_points_2(contract_id, add) do
    contract = get_contract!(contract_id)
    add_points(contract, add)
  end

  def get_contract_by_brand_and_influencer(brand_id, influencer_id),
    do: Repo.get_by(Contract, brand_id: brand_id, influencer_id: influencer_id)

  def get_contract_by_brand_and_user(brand_id, user_id),
    do: Repo.get_by(Contract, brand_id: brand_id, user_id: user_id)

  def get_total_contract_revenue(contract_id) do
    contract = get_contract!(contract_id)
    vouchers = contract.voucher
    get_value(vouchers)
  end

  def get_value([voucher | vouchers]) do
    a = Decimal.new(Vouchers.get_total_voucher_revenue(voucher.id))
    b = Decimal.new(get_value(vouchers))
    Decimal.add(a, b)
  end

  def get_value([]) do
    Decimal.new(0)
  end

  def get_number_of_sales(contract_id) do
    contract = get_contract!(contract_id)
    get_vouchers_sales(contract.voucher)
  end

  def get_vouchers_sales([voucher | vouchers]) do
    Vouchers.get_number_of_sales(voucher.id) + get_vouchers_sales(vouchers)
  end

  def get_vouchers_sales([]) do
    0
  end

  def get_total_contract_views(contract_id) do
    contract = get_contract!(contract_id)
    get_vouchers_views(contract.voucher)
  end

  def get_vouchers_views([voucher | vouchers]) do
    voucher.views_counter + get_vouchers_views(vouchers)
  end

  def get_vouchers_views([]) do
    0
  end

  def get_contract_customers(contract_id) do
    contract = get_contract!(contract_id)
    customers = get_customers_from_voucher(contract.voucher)
  end

  def get_customers_from_voucher([voucher | vouchers]) do
    custumers = Vouchers.get_voucher_customers(voucher.id) ++ get_customers_from_voucher(vouchers)
  end

  def get_customers_from_voucher([]) do
    []
  end

  def get_contract_pending_payments(contract_id) do
    contract = get_contract!(contract_id) |> Repo.preload(:payments)
    total = get_pending_payments(contract.payments)
  end

  def get_pending_payments([payment | payments]) do
    case payment.status do
      "pending" ->
        payment.value + get_pending_payments(payments)

      _ ->
        get_pending_payments(payments)
    end
  end

  def get_pending_payments([]) do
    0
  end

  def get_sales_countries(contract_id) do
    contract = get_contract!(contract_id)
    get_sales_countries_from_vouchers(contract.voucher)
  end

  def get_sales_countries_from_vouchers([voucher | vouchers]) do
    Vouchers.get_sales_countries(voucher.id) ++ get_sales_countries_from_vouchers(vouchers)
  end

  def get_sales_countries_from_vouchers([]) do
    []
  end

  def get_brands(%Contract{} = contract) do
    query =
      Contract
      |> where([c], c.user_id == ^contract.user_id)
      |> join(:inner, [c], brand in assoc(c, :brand))
      |> distinct(true)
      |> select([_, brand], brand)

    Repo.all(query)
  end

  def get_payments(%Contract{} = contract) do
    query =
      App.Payments.Payment
      |> where([p], p.contract_id == ^contract.id)
      |> select([p], p)

    Repo.all(query)
  end
end
