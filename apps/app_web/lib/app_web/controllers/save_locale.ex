defmodule AppWeb.SaveLocale do
    import Plug.Conn
  
    def init(_opts), do: nil
  
    def call(conn, _opts) do
      case conn.assigns[:locale] || get_session(conn, :locale) do
        nil     ->
          Gettext.put_locale(AppWeb.Gettext, "en")
          conn |> put_session(:locale, "en")
        locale  ->
          Gettext.put_locale(AppWeb.Gettext, locale)
          conn |> put_session(:locale, locale)
      end
    end
  end
