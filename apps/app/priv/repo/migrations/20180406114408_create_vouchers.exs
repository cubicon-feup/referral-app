defmodule App.Repo.Migrations.CreateVouchers do
  use Ecto.Migration

  def change do
    create table(:vouchers) do
      add :amount, :decimal
      add :free_shipping, :boolean, default: false, null: false
      add :expiration_date, :naive_datetime
      add :minimum_spent_to_use, :decimal
      add :maximum_spent_to_use, :decimal
      add :comulative_with_vouchers, :boolean, default: false, null: false
      add :comulative_with_sales, :boolean, default: false, null: false
      add :uses_per_person, :integer
      add :uses, :integer
      add :contract_id, references(:contract, on_delete: :nothing)

      timestamps()
    end

    create index(:vouchers, [:contract_id])
  end
end
