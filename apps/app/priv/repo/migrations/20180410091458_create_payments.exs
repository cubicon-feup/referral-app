defmodule App.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    execute("create type payment_status as enum ('pending', 'complete', 'cancelled')", "drop type payment_status")
    execute("create type payment_type as enum ('money', 'voucher', 'products')", "drop type payment_type")
 
    create table(:payments) do
      add :request_date, :naive_datetime, default: fragment("now()") 
      add :payment_date, :naive_datetime
      add :deadline_date, :naive_datetime
      add :status, :payment_status, default: "pending", null: false
      add :type, :payment_type, null: false
      add :value, :decimal
      add :description, :string
      add :brand_id, references(:brands, on_delete: :nothing)
      add :contract_id, references(:contracts, on_delete: :nothing)

      timestamps()
    end

    create index(:payments, [:brand_id])
    create index(:payments, [:contract_id])
  end
end
