defmodule App.Repo.Migrations.UpdateBrandsTable do
  use Ecto.Migration

  def change do
    alter table(:influencers) do
  add :user_id,  references(:users, on_delete: :nothing)
  remove :influencer_id
end

  end
end
