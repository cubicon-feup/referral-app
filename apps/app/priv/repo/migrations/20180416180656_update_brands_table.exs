defmodule App.Repo.Migrations.UpdateBrandsTable do
  use Ecto.Migration

  def change do
    alter table(:brands) do
  add :user_id,  references(:users, on_delete: :nothing)
  remove :brand_id
end

  end
end
