defmodule App.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payment) do
      add :requestDate, :naive_datetime, null: false
      add :paid, :boolean, default: false, null: false
      add :value, :decimal, null: false
      add :brand_id, references(:brand, on_delete: :nothing), null: false
      add :influencer_id, references(:influencer, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:payment, [:influencer_id])
    create index(:payment, [:brand_id])
  end
end
