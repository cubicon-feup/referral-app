defmodule App.Repo.Migrations.UpdateInfluencerTable do
  use Ecto.Migration

  def change do
    alter table(:influencers) do
    add :contact, :string
    end
  end
end
