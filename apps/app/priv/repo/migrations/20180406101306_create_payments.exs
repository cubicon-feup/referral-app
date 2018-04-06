defmodule App.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payment) do
      add :requestDate, :naive_datetime
      add :paid, :boolean, default: false, null: false
      add :value, :decimal
      add :brand_id, references(:brand, on_delete: :nothing)
      add :influencer_id, references(:influencer, on_delete: :nothing)

      timestamps()
    end

    create index(:payment, [:influencer_id])
    create index(:payment, [:brand_id])
  end
end
