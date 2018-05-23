defmodule App.Vouchers do
  @moduledoc """
  The Vouchers context.
  """

  import Ecto.Query, warn: false
  alias App.Repo
  alias App.Contracts
  alias App.Sales


  alias App.Vouchers.Voucher

  @doc """
  Returns the list of vouchers.

  ## Examples

      iex> list_vouchers()
      [%Voucher{}, ...]

  """
  def list_vouchers do
    Ecto.assoc(Voucher, :contracts)
  end

  @doc """
  Gets a single voucher.

  Raises `Ecto.NoResultsError` if the Voucher does not exist.

  ## Examples

      iex> get_voucher!(123)
      %Voucher{}

      iex> get_voucher!(456)
      ** (Ecto.NoResultsError)

  """
  def get_voucher!(id) do
    voucher =
      Repo.get!(Voucher, id)
      |> Repo.preload(:contract)
      |> Repo.preload(:sales)

    case voucher do
      voucher ->
        {:ok, voucher}

      nil ->
        {:error, :not_found}
    end
  end

  @doc """
  Creates a voucher.

  ## Examples

      iex> create_voucher(%{field: value})
      {:ok, %Voucher{}}

      iex> create_voucher(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_voucher(attrs \\ %{}) do
    %Voucher{}
    |> Voucher.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a voucher.

  ## Examples

      iex> update_voucher(voucher, %{field: new_value})
      {:ok, %Voucher{}}

      iex> update_voucher(voucher, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_voucher(%Voucher{} = voucher, attrs) do
    voucher
    |> Voucher.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Voucher.

  ## Examples

      iex> delete_voucher(voucher)
      {:ok, %Voucher{}}

      iex> delete_voucher(voucher)
      {:error, %Ecto.Changeset{}}

  """
  def delete_voucher(%Voucher{} = voucher) do
    Repo.delete(voucher)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking voucher changes.

  ## Examples

      iex> change_voucher(voucher)
      %Ecto.Changeset{source: %Voucher{}}

  """
  def change_voucher(%Voucher{} = voucher) do
    Voucher.changeset(voucher, %{})
  end

  def get_vouchers_by_contract!(contract_id) do
    Repo.all(from(voucher in Voucher, where: [contract_id: ^contract_id]))
  end

  def add_sale(%Voucher{} = voucher, sale_value) do
    # add_sale
    new_counter = voucher.sales_counter + 1

    # calculate points
    fixed =
      if voucher.set_of_sales != 0 and Integer.mod(new_counter, voucher.set_of_sales) == 0 do
        Decimal.to_float(voucher.points_on_sales)
      else
        0
      end

    percent = Float.floor(Decimal.to_float(voucher.percent_on_sales) * sale_value, 2)
    points = fixed + percent

    # check if not zero
    if points != 0 do
      contract = Contracts.get_contract!(voucher.contract_id)
      Contracts.add_points(contract, points)
    end

    # update
    update_voucher(voucher, %{sales_counter: new_counter})
  end

  def add_view(%Voucher{} = voucher) do
    # add_sale
    new_counter = voucher.views_counter + 1

    # calculate points
    points =
      if voucher.set_of_views != 0 and Integer.mod(new_counter, voucher.set_of_views) == 0 do
        Decimal.to_float(voucher.points_on_views)
      else
        0
      end

    # check if not zero
    if points != 0 do
      contract = Contracts.get_contract!(voucher.contract_id)
      Contracts.add_points(contract, points)
    end

    # update
    update_voucher(voucher, %{views_counter: new_counter})
  end

  def get_voucher_by_code_and_brand_hostname(code, brand_hostname) do
    voucher =
      Repo.one(
        from(
          v in Voucher,
          join: c in assoc(v, :contract),
          join: b in assoc(c, :brand),
          preload: [{:contract, :brand}, {:contract, :influencer}],
          where: v.code == ^code and b.hostname == ^brand_hostname
        )
      )

    #   Repo.get_by(Voucher, code: code)
    #   |> Repo.preload(:contract)
    #   |> Repo.preload(contract: :brand)
    #
    # IO.inspect(vouchers.contract.brand.hostname, label: "vouchers")
  end


  def get_total_voucher_revenue(voucher_id) do
    case get_voucher!(voucher_id) do
      {:ok, voucher} ->
        sales = voucher.sales
        get_value(sales)
      {:error, _} ->
        ()
    end
  end

  def get_value([sale|sales]) do
    a = Decimal.new(sale.value)
    b = Decimal.new(get_value(sales))
    Decimal.add(a,b)
  end

  def get_value([]) do
    Decimal.new(0)
  end

  def get_number_of_sales(voucher_id) do
    {:ok, voucher} = get_voucher!(voucher_id)

    Enum.count(voucher.sales)
  end
end
