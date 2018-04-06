defmodule App.Repo.Migrations.CreatePaymentVoucher do
  use Ecto.Migration

  def change do
    create table(:payment_voucher) do
      add :amount, :decimal
      add :expiration_date, :naive_datetime
      add :minimum_spent_to_use, :decimal
      add :maximum_spent_to_use, :decimal
      add :comulative_with_vouchers, :boolean, default: false, null: false
      add :comulative_with_sales, :boolean, default: false, null: false
      add :payment_id, references(:payment, on_delete: :nothing)

      timestamps()
    end

    create index(:payment_voucher, [:payment_id])
  end
end
