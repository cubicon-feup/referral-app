defmodule AppWeb.InfluencerController do
  use AppWeb, :controller

  alias App.Influencers
  alias App.Influencers.Influencer

  action_fallback AppWeb.FallbackController

  def index(conn, _params) do
    influencers = Influencers.list_influencers()
    render(conn, "index.json", influencers: influencers)
  end

  def create(conn, %{"influencer" => influencer_params}) do
    with {:ok, %Influencer{} = influencer} <- Influencers.create_influencer(influencer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", influencer_path(conn, :show, influencer))
      |> render("show.json", influencer: influencer)
    end
  end

  def show(conn, %{"id" => id}) do
    influencer = Influencers.get_influencer!(id)
    render(conn, "show.json", influencer: influencer)
  end

  def update(conn, %{"id" => id, "influencer" => influencer_params}) do
    influencer = Influencers.get_influencer!(id)

    with {:ok, %Influencer{} = influencer} <- Influencers.update_influencer(influencer, influencer_params) do
      render(conn, "show.json", influencer: influencer)
    end
  end

  def delete(conn, %{"id" => id}) do
    influencer = Influencers.get_influencer!(id)
    with {:ok, %Influencer{}} <- Influencers.delete_influencer(influencer) do
      send_resp(conn, :no_content, "")
    end
  end
end
