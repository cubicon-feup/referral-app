defmodule App.Repo.Migrations.CreateInfluencers do
  use Ecto.Migration

  def change do
    create table(:influencer) do
      add :name, :string
      add :address, :string
      add :nib, :integer
      add :code, :string
      add :influencer_id, references(:user, on_delete: :nothing)

      timestamps()
    end

  end
end
