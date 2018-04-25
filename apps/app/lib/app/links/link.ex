defmodule App.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset


  schema "links" do
    field :shortcode, :string
    field :url, :string
    field :influencer_id, :id

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :shortcode])
    |> validate_required([:url, :shortcode])
  end
end
