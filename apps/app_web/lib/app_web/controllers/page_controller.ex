defmodule AppWeb.PageController do
  use AppWeb, :controller

  alias App.Users

  def init(conn, _params) do

    case conn.params["locale"] || get_session(conn, :locale) do
      nil     -> redirect(conn, to: "/en/")
      locale  ->
        Gettext.put_locale(AppWeb.Gettext, locale)
        conn |> put_session(:locale, locale)
        redirect(conn, to: "/" <> to_string(get_session(conn, :locale)) <> "/")
    end

  end

  def index(conn, _params) do
    case Guardian.Plug.current_resource(conn) do 
      nil ->
        conn 
        |> redirect(to: user_path(conn, :index))
      user ->
        case get_session(conn, :brand_id) do
          nil ->
            conn 
            |> redirect(to: user_path(conn, :show, user.id))
          brand_id ->
            conn 
            |> redirect(to: brand_path(conn, :index))
        end
    end
  end
end
