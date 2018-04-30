defmodule AppWeb.InfluencerController do
  use AppWeb, :controller

  alias App.Influencers
  alias App.Influencers.Influencer
  alias App.Brands
  alias App.Repo

  def index(conn, _params) do
    case Plug.Conn.get_session(conn, :brand_id) do
      nil ->
        conn
        |> put_flash(:info, "You must be a brand to see this content.")
        |> redirect(to: "/")
      brand_id ->
        brand = Brands.get_brand(brand_id) 
                |> Repo.preload(:contracts)

        influencers =
          for contract <- brand.contracts do
            contract = contract |> Repo.preload(:influencer)
            contract.influencer
          end
        IO.inspect(influencers, label: "Inf::::::::::::")
        render(conn, "index.html", influencers: influencers)
    end
  end

  def new(conn, _params) do
    changeset = Influencers.change_influencer(%Influencer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"influencer" => influencer_params}) do
    case Influencers.create_influencer(influencer_params) do
      {:ok, influencer} ->
        conn
        |> put_flash(:info, "Influencer created successfully.")
        |> redirect(to: influencer_path(conn, :show, influencer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    influencer = Influencers.get_influencer!(id)
    render(conn, "show.html", influencer: influencer)
  end

  def edit(conn, %{"id" => id}) do
    influencer = Influencers.get_influencer!(id)
    changeset = Influencers.change_influencer(influencer)
    render(conn, "edit.html", influencer: influencer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "influencer" => influencer_params}) do
    influencer = Influencers.get_influencer!(id)

    case Influencers.update_influencer(influencer, influencer_params) do
      {:ok, influencer} ->
        conn
        |> put_flash(:info, "Influencer updated successfully.")
        |> redirect(to: influencer_path(conn, :show, influencer))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", influencer: influencer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    influencer = Influencers.get_influencer!(id)
    {:ok, _influencer} = Influencers.delete_influencer(influencer)

    conn
    |> put_flash(:info, "Influencer deleted successfully.")
    |> redirect(to: influencer_path(conn, :index))
  end
end
