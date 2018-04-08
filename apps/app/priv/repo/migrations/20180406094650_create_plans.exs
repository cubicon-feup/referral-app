defmodule App.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plan) do
      add :name, :string, null: false
      add :max_influencers, :integer, null: false

      timestamps()
    end

    create unique_index(:plan, [:name])
  end
end
