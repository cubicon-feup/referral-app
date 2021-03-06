defmodule App.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :status, :string, default: "pending"
    field :request_date, :naive_datetime
    field :payment_date, :naive_datetime
    field :deadline_date, :naive_datetime
    field :type, :string
    field :description, :string
    field :value, :decimal
    belongs_to :contract, App.Contracts.Contract

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:request_date, :payment_date, :deadline_date, :type, :status, :value, :description, :contract_id])
    |> cast_assoc(:contract)
    |> validate_required([:contract_id, :type, :value])
    |> validate_inclusion(:status, ["pending", "complete", "cancelled"])
    |> validate_inclusion(:type, ["money", "voucher", "products"])
  end

  @doc false
  defp check_payment_date(payment, status) do
    if Map.has_key?(payment.changes, :status) and payment.changes.status == "complete" do
      change(payment, payment_date: Ecto.DateTime.utc(:usec))
    else
      payment
    end
  end
end
