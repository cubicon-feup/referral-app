defmodule App.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :request_date, :naive_datetime
      add :paid, :boolean, default: false, null: false
      add :value, :decimal
      add :brand_id, references(:brands, on_delete: :nothing)
      add :influencer_id, references(:influencers, on_delete: :nothing)

      timestamps()
    end

    create index(:payments, [:brand_id])
    create index(:payments, [:influencer_id])
  end
end
