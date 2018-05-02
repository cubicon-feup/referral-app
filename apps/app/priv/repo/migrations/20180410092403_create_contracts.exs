defmodule App.Repo.Migrations.CreateContracts do
  use Ecto.Migration

  def change do
    
    create table(:contracts) do
      add :influencer_id, references(:influencers, on_delete: :nothing)
      add :brand_id, references(:brands, on_delete: :nothing)
      add :minimum_points, :integer
      add :payment_period, :integer
      add :points, :decimal

      timestamps()
    end

    create unique_index(:contracts, [:brand_id, :influencer_id], name: :index_brand_influencer)

  end
end
