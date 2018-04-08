defmodule App.Payment_vouchers do
  @moduledoc """
  The Payment_vouchers context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Payment_vouchers.Payment_voucher

  @doc """
  Returns the list of payment_voucher.

  ## Examples

      iex> list_payment_voucher()
      [%Payment_voucher{}, ...]

  """
  def list_payment_voucher do
    Repo.all(Payment_voucher)
  end

  @doc """
  Gets a single payment_voucher.

  Raises `Ecto.NoResultsError` if the Payment voucher does not exist.

  ## Examples

      iex> get_payment_voucher!(123)
      %Payment_voucher{}

      iex> get_payment_voucher!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment_voucher!(id), do: Repo.get!(Payment_voucher, id)

  @doc """
  Creates a payment_voucher.

  ## Examples

      iex> create_payment_voucher(%{field: value})
      {:ok, %Payment_voucher{}}

      iex> create_payment_voucher(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment_voucher(attrs \\ %{}) do
    %Payment_voucher{}
    |> Payment_voucher.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment_voucher.

  ## Examples

      iex> update_payment_voucher(payment_voucher, %{field: new_value})
      {:ok, %Payment_voucher{}}

      iex> update_payment_voucher(payment_voucher, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment_voucher(%Payment_voucher{} = payment_voucher, attrs) do
    payment_voucher
    |> Payment_voucher.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Payment_voucher.

  ## Examples

      iex> delete_payment_voucher(payment_voucher)
      {:ok, %Payment_voucher{}}

      iex> delete_payment_voucher(payment_voucher)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment_voucher(%Payment_voucher{} = payment_voucher) do
    Repo.delete(payment_voucher)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment_voucher changes.

  ## Examples

      iex> change_payment_voucher(payment_voucher)
      %Ecto.Changeset{source: %Payment_voucher{}}

  """
  def change_payment_voucher(%Payment_voucher{} = payment_voucher) do
    Payment_voucher.changeset(payment_voucher, %{})
  end
end
