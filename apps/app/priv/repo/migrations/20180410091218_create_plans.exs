defmodule App.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :name, :string
      add :max_influencers, :integer

      timestamps()
    end

  end
end
