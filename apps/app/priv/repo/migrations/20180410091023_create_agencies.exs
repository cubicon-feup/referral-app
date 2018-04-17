defmodule App.Repo.Migrations.CreateAgencies do
  use Ecto.Migration

  def change do
    create table(:agencies) do
      add :name, :string
      add :agency_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:agencies, [:agency_id])
  end
end
