defmodule App.Clients.Client do
  use Ecto.Schema
  import Ecto.Changeset


  schema "client" do
    field :age, :integer
    field :client_id, :integer
    field :country, :string
    field :gender, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:client_id, :country, :gender, :age])
    |> validate_required([:client_id, :country, :gender, :age])
  end
end
