defmodule AppWeb.UserController do
  use AppWeb, :controller

  alias App.Users
  alias App.Users.User
  alias App.Auth
  alias App.Auth.Guardian


  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    case user.deleted do
      true ->
        put_flash(conn, :warning, "User deleted account.")
        |> redirect(to: "/")
        |> halt()
      false ->
        render(conn, "show.html", user: user)
    end
  end

  def edit(conn, %{"id" => id}) do
    user_id = Integer.to_string(Guardian.Plug.current_resource(conn).id)
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> redirect(to: user_path(conn, :index))
      user ->
        case user_id == id do
          true ->
            user = Users.get_user!(id)
            changeset = Users.change_user(user)
            render(conn, "edit.html", user: user, changeset: changeset, page_title: "Profile Page")
          false ->
            user = Users.get_user!(user_id)
            conn
            |> redirect(to: user_path(conn, :edit, user))
        end
    end
  end

  def update(conn, %{"user" => user_params}) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> redirect(to: user_path(conn, :index))
      user ->
        case Users.update_user(user, user_params) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User updated successfully.")
            |> redirect(to: user_path(conn, :edit, user))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", user: user, changeset: changeset, page_title: "Edit Profile")
        end
    end
  end

  def update_password(conn, %{"user" => user_params}) do
    case Auth.authenticate_user(Guardian.Plug.current_resource(conn).email, user_params["current_password"]) do
      {:ok, _result} ->
        confirm_new_password(conn, %{"id" => Guardian.Plug.current_resource(conn).id, "user" => user_params})
      {:error, _error} ->
        conn
        |> put_flash(:error, "Invalid Current Password")
        |> redirect(to: user_path(conn, :edit, Guardian.Plug.current_resource(conn).id))
    end
  end

  def confirm_new_password(conn, %{"user" => user_params}) do
    case String.equivalent?(user_params["password"], user_params["password_confirmation"]) do
      true ->
        update(conn, %{"id" => Guardian.Plug.current_resource(conn).id, "user" => user_params})
      false ->
        conn
        |> put_flash(:error, "Passwords don't match")
        |> redirect(to: user_path(conn, :edit, Guardian.Plug.current_resource(conn).id))
    end
  end

  def delete(conn, _params) do
    user = Users.get_user!(Guardian.Plug.current_resource(conn).id)

    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def login(
        conn,
        %{
          "user" => %{
            "email" => email,
            "password" => password
          }
        }
      ) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        case user.deleted do
          true ->
            login_reply({:error, "The account was deleted."}, conn)
          false ->
            login_reply({:ok, user}, conn)
        end
      {:error, error} ->
        login_reply({:error, error}, conn)
    end
  end

  defp login_reply({:error, error}, conn) do
    conn
    |> put_flash(:error, error)
    |> redirect(to: user_path(conn, :index))
  end

  defp login_reply({:ok, user}, conn) do
    put_flash(conn, :success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
    |> halt()
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: user_path(conn, :index))
  end

end
