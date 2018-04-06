defmodule App.Repo.Migrations.CreateAgencies do
  use Ecto.Migration

  def change do
    create table(:agency) do
      add :name, :string
      add :agency_id, references(:user, on_delete: :nothing)

      timestamps()
    end

  end
end
