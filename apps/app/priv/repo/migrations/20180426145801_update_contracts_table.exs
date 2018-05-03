defmodule App.Repo.Migrations.UpdateContractsTable do
  use Ecto.Migration

  def change do
    alter table(:contracts) do
      add(:voucher_id, references(:vouchers, on_delete: :nothing))
    end
  end
end
