defmodule App.Contracts do
  @moduledoc """
  The Contracts context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Contracts.Contract

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

  def get_brands(%Contract{} = contract) do
    query = Contract
    |> where([c], c.user_id == ^contract.user_id) 
    |> join( :inner, [c], brand in assoc(c, :brand))
    |> distinct(true)
    |> select([_, brand], brand)

    Repo.all(query)
  end

  def get_payments(%Contract{} = contract) do
    query = App.Payments.Payment
    |> where([p], p.contract_id == ^contract.id)
    |> select([p], p)

    Repo.all(query)
  end
end
