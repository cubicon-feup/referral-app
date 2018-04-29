defmodule AppWeb.LayoutView do
  use AppWeb, :view

  alias App.Brands
  alias App.Influencers
  alias App.Users
  @doc """
  Generates name for the JavaScript view we want to use
  in this combination of view/template.
  """
  def js_view_name(conn) do
    [view_name(conn)]
    |> Enum.reverse
    |> List.insert_at(0, "view")
    |> Enum.map(&String.capitalize/1)
    |> Enum.reverse
    |> Enum.join("")
  end

  # Takes the resource name of the view module and removes the
  # the ending *_view* string.
  defp view_name(conn) do
    conn
    |> view_module
    |> Phoenix.Naming.resource_name
    |> String.replace("_view", "")
  end

  defp get_locale(conn) do
    conn
    |> Plug.Conn.get_session(:locale)
  end

  defp get_brand(conn) do
    conn
    |> Plug.Conn.get_session(:brand_id)
    |> Brands.get_brand()
    
  end

  defp get_user(conn) do
    conn
    |> Guardian.Plug.current_resource
  end
end
