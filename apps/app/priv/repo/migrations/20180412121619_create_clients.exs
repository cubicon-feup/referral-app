defmodule App.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients) do
      add :client_id, :integer
      add :country, :string
      add :gender, :boolean, default: false, null: false
      add :age, :integer

      timestamps()
    end

  end
end
