defmodule App.Repo.Migrations.CreateAgencies do
  use Ecto.Migration

  def change do
    create table(:agency) do
      add :name, :string, null: false
      add :agency_id, references(:user, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:agency, [:name])
  end
end
