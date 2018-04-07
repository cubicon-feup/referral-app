defmodule App.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:client) do
      add :client_id, :integer, null: false
      add :country, :string, null: false
      add :gender, :boolean, default: false, null: false
      add :age, :integer, null: false

      timestamps()
    end

    create index(:client, [:client_id])
  end
end
