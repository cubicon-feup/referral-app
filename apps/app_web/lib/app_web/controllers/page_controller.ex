defmodule AppWeb.PageController do
  use AppWeb, :controller

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
        redirect(conn, to: "/user")
      user ->
        render("index.html")

    end
  end
end
