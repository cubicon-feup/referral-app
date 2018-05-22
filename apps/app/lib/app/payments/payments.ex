defmodule App.Payments do
  @moduledoc """
  The Payments context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Payments.Payment
  alias App.Contracts.Contract

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments()
      [%Payment{}, ...]

  """
  def list_payments do
    Repo.all(Payment)
    |> Repo.preload(:contract)
  end

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments_brand()
      [%Payment{}, ...]

  """
  def list_payments_brand(brand_id) do
    query = from p in Payment,
      join: c in Contract, on: [id: p.contract_id],
      select: %{
        status: p.status,
        request_date: p.request_date,
        payment_date: p.payment_date,
        type: p.type,
        description: p.description,
        value: p.value,
        contract_id: c.id,
        contract_name: c.name
      }
    Repo.all(query)
  end


  @doc """
  Gets a single payment.

  Raises `Ecto.NoResultsError` if the Payment does not exist.

  ## Examples

      iex> get_payment!(123)
      %Payment{}

      iex> get_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment!(id) do
    Repo.get!(Payment, id)
    |> Repo.preload(:contract)
  end

  @doc """
  Creates a payment.

  ## Examples

      iex> create_payment(%{field: value})
      {:ok, %Payment{}}

      iex> create_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment(attrs \\ %{}) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment.

  ## Examples

      iex> update_payment(payment, %{field: new_value})
      {:ok, %Payment{}}

      iex> update_payment(payment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment(%Payment{} = payment, attrs) do
    payment
    |> Payment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Payment.

  ## Examples

      iex> delete_payment(payment)
      {:ok, %Payment{}}

      iex> delete_payment(payment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment(%Payment{} = payment) do
    Repo.delete(payment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment changes.

  ## Examples

      iex> change_payment(payment)
      %Ecto.Changeset{source: %Payment{}}

  """
  def change_payment(%Payment{} = payment) do
    Payment.changeset(payment, %{})
  end
end
