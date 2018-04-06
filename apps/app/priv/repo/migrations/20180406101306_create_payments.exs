defmodule App.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :requestDate, :naive_datetime
      add :paid, :boolean, default: false, null: false
      add :value, :decimal
      add :influencer_id, references(:influencer, on_delete: :nothing)
      add :brand_id, references(:brand, on_delete: :nothing)

      timestamps()
    end

    create index(:payments, [:influencer_id])
    create index(:payments, [:brand_id])
  end
end
