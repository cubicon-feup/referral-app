defmodule App.Repo.Migrations.CreateVouchers do
  use Ecto.Migration

  def change do
    create table(:vouchers) do
      add :code, :string
      add :rule_id, references(:rules, on_delete: :nothing)

      timestamps()
    end

    create index(:vouchers, [:rule_id])
  end
end
