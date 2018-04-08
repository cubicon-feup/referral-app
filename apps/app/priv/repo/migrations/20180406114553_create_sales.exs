defmodule App.Repo.Migrations.CreateSales do
  use Ecto.Migration

  def change do
    create table(:sale) do
      add :date, :naive_datetime, null: false
      add :value, :decimal, null: false
      add :contract_id, references(:contract, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:sale, [:contract_id])
  end
end
