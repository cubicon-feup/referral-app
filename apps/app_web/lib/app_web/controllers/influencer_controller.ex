defmodule AppWeb.InfluencerController do
  use AppWeb, :controller

  alias App.Influencers
  alias App.Influencers.Influencer

  alias App.Users
  alias App.Users.User

  alias AppWeb.UserController

  alias AppWeb.PageNotFoundController

  def index(conn, _params) do
    influencers = Influencers.list_influencers()
    render(conn, "index.html", influencers: influencers)
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

  def invited_new_user(conn, %{"email" => email, "name" => name}) do
    case Influencers.get_influencer_by_email!(email) do
      nil->
        IO.inspect "here"
        PageNotFoundController.error(conn, %{})
      influencer->
        case Users.get_user_by_email!(email) do
          nil->
            if influencer.user_id == nil do
              changeset = Users.change_user(%User{})
              render(conn, "invited_create_user.html", changeset: changeset, email: email, name: name)
            else
              IO.inspect "here3"
              PageNotFoundController.error(conn, %{})
            end
          user->
            PageNotFoundController.error(conn, %{})
        end
    end
  end

  def invited_create_user(conn, %{"email" => email, "name" => name, "user" => user_params}) do
    case String.equivalent?(user_params["password_confirmation"], user_params["password"]) do
      true ->
        case Users.create_user(user_params) do
          {:ok, user} ->
            influencer = Influencers.get_influencer_by_email!(user.email)
            changeset = Influencers.change_influencer(influencer)

            conn
            |> UserController.login_from_influencer(user_params)
            |> put_flash(:info, "User created successfully.")
            |> render("invited_update_influencer.html", influencer: influencer, changeset: changeset, user: user)
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "invited_create_user.html", changeset: changeset)
        end
      false ->
        changeset = Users.change_user(%User{})
        conn
        |> put_flash(:warning, "Passwords don't match.")
        |> redirect(to: influencer_path(conn, :invited_new_user, email, name))
    end
  end

  def invited_update_influencer(conn, %{"id" => id, "influencer" => influencer_params}) do
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
end
