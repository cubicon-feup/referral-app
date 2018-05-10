defmodule AppWeb.Api.LinkController do
  use AppWeb, :controller

  alias App.Links
  alias App.Brands
  alias App.Cache

    @doc """
  Create a shortened URL.

  If there are errors the form will be redisplayed.

  If the url has already been shortened it just shows the existing record.

  If all is good and the url hasn't been shortened yet it generates the
  shortcode and also adds the current user to the record.

  Either success path will warm the cache with the shortcode on the assumption
  it will be used soon.
  """
  def create(conn, %{"discount_code" => discount_code, "voucher_id" => voucher_id}) do
    case Plug.Conn.get_session(conn, :brand_id) do
      nil ->
        ()
      brand_id ->
        brand = Brands.get_brand!(brand_id)
        url = "https://" <> brand.hostname <> "/discount/" <> discount_code
        shortened_url = Links.link_from_url(url)
        do_create(conn, shortened_url, url, voucher_id)
    end
  end

  # when the url hasn't been shortened before try to create the short version
  defp do_create(conn, nil, url, voucher_id) do
    link_params = Map.merge(%{"url" => url, "voucher_id" => voucher_id}, %{"user_id" => Guardian.Plug.current_resource(conn).id})
    case Links.create_link(link_params) do
      {:ok, link} ->
        Cache.warm(link.shortcode)
        json conn, %{shortcode: link.shortcode}
      {:error, changeset} ->
        json conn, changeset: changeset
    end
  end
  # when the url has been shortened before just show the existing record
  defp do_create(conn, link, _link_params, _voucher_id) do
    Cache.warm(link.shortcode)
    json conn, %{shortcode: link.shortcode}
  end

  def delete(conn, %{"id" => id}) do
    link = Links.get_link!(id)
    {:ok, _link} = Links.delete_link(link)

    json conn, message: "Link deleted successfully."
  end
end
