defmodule App.Repo.Migrations.CreateVouchers do
  use Ecto.Migration

  def change do
    create table(:vouchers) do
      add :code, :string
      add :contract_id, references(:contracts, on_delete: :nothing)

      timestamps()
    end

    create index(:vouchers, [:contract_id])
  end
end
