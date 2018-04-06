defmodule AppWeb.ClientView do
  use AppWeb, :view
  alias AppWeb.ClientView

  def render("index.json", %{clients: clients}) do
    %{data: render_many(clients, ClientView, "client.json")}
  end

  def render("show.json", %{client: client}) do
    %{data: render_one(client, ClientView, "client.json")}
  end

  def render("client.json", %{client: client}) do
    %{id: client.id,
      client_id: client.client_id,
      country: client.country,
      gender: client.gender,
      age: client.age}
  end
end
