defmodule App.Repo.Migrations.UpdateInfluencerTable do
  use Ecto.Migration

  def change do
    alter table(:influencers) do
    add :contact, :string
    add(:contract_id, references(:contracts, on_delete: :nothing))
    end
  end
end
