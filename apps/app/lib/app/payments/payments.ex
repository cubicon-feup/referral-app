defmodule App.Payments do
  @moduledoc """
  The Payments context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Payments.Payment
  alias App.Influencers.Influencer

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments()
      [%Payment{}, ...]

  """
  def list_payments do
    Repo.all(Payment)
    |> Repo.preload(:influencer)
  end

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments_brand()
      [%Payment{}, ...]

  """
  def list_payments_brand(brand_id) do
    query = from p in Payment,
      join: i in Influencer, on: [id: p.influencer_id],
      select: %{
        status: p.status,
        request_date: p.request_date,
        payment_date: p.payment_date,
        type: p.type,
        description: p.description,
        value: p.value,
        brand_id: p.brand_id,
        influencer_id: i.id,
        influencer_name: i.name
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
    |> Repo.preload(:influencer)
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
       
    if !check_fields(attrs) do
      {:error, Payment.changeset( %Payment{}, attrs)}
    else
      contract = App.Contracts.get_contract_by_brand_and_influencer(attrs["brand_id"], attrs["influencer_id"])
      {value, _} = Float.parse(attrs["value"]) 
      temp_attrs = Enum.into(%{"status" => "pending"}, attrs)

      if !check_points(contract, value) do
        {:error_no_points, Payment.changeset(%Payment{}, attrs)}
      else
        App.Contracts.add_points(contract, value * -1)

        {:ok, payment} = %Payment{}
        |> Payment.changeset(temp_attrs)
        |> Repo.insert()

        if attrs["status"] == "complete" do
          complete_payment(payment)
        else
          {:ok, payment} 
        end
      end
    end
  end

  defp check_fields(attrs \\ %{}) do
    Payment.changeset( %Payment{}, attrs).valid?
  end

  defp check_points(contract, value) do
    Decimal.to_float(contract.points) >= value && Decimal.to_float(contract.points) >= Decimal.to_float(contract.minimum_points)
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


  def complete_payment(%Payment{} = payment) do
    if(payment.status == "pending") do
      update_payment(payment, %{"status" => "complete", "payment_date" => NaiveDateTime.utc_now});
    else
      {:ok, payment}
    end
  end

  def cancel_payment(%Payment{} = payment) do
    contract = App.Contracts.get_contract_by_brand_and_influencer(payment.brand_id, payment.influencer_id)
    
    if(payment.status == "pending") do
      App.Contracts.add_points(contract, Decimal.to_float(payment.value))
      update_payment(payment, %{"status" => "cancelled"});
    else
      {:ok, payment}
    end
  end
end
