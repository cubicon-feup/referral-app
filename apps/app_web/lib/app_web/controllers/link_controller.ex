defmodule AppWeb.LinkController do
  use AppWeb, :controller

  alias App.Links
  alias App.Links.Link
  alias App.Cache
  alias App.Vouchers

  def index(conn, _params) do
    links = Links.list_links()
    render(conn, "index.html", links: links)
  end

  def new(conn, _params) do
    changeset = Link.new()
    render(conn, "new.html", changeset: changeset)
  end

    @doc """
  Create a shortened URL.

  If there are errors the form will be redisplayed.

  If the url has already been shortened it just shows the existing record.

  If all is good and the url hasn't been shortened yet it generates the
  shortcode and also adds the current user to the record.

  Either success path will warm the cache with the shortcode on the assumption
  it will be used soon.
  """
  def create(conn, %{"link" => link_params}) do
    # try to find an existing url
    link = case link_params["url"] do
      nil -> nil
      url -> Links.link_from_url(url)
    end

    do_create(conn, link, link_params)
  end

  # when the url hasn't been shortened before try to create the short version
  defp do_create(conn, nil, link_params) do
    link_params = Map.merge(link_params, %{"user_id" => Guardian.Plug.current_resource(conn).id})
    case Links.create_link(link_params) do
      {:ok, link} ->
        Cache.warm(link.shortcode)

        conn
        |> put_flash(:info, "Link created successfully.")
        |> redirect(to: link_path(conn, :show, link.id))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
  # when the url has been shortened before just show the existing record
  defp do_create(conn, link, _link_params) do
    Cache.warm(link.shortcode)
    conn
    |> put_flash(:info, "Link already existed in short format.")
    |> redirect(to: link_path(conn, :show, link.id))
  end

  @doc """
  Redirect to the target url.

  If the shortcode wasn't in the cache then add it.

  If the shortcode isn't in the database render a 404.
  """
  def unshorten(conn, %{"shortcode" => shortcode}) do
    case App.Cache.get_url(shortcode) do
      nil ->
        conn
        |> fetch_session
        |> fetch_flash
        |> put_status(:not_found)
        |> render(AppWeb.ErrorView, "404.html")
      url ->
        link = Links.link_from_shortcode(shortcode)
        {:ok, voucher} = Vouchers.get_voucher!(link.voucher_id)
        Vouchers.add_view(voucher)
        conn
        |> put_status(:moved_permanently)
        |> redirect(external: url)
    end
  end

  def show(conn, %{"id" => id}) do
    link = Links.get_link!(id)
    render(conn, "show.html", link: link)
  end

  def edit(conn, %{"id" => id}) do
    link = Links.get_link!(id)
    changeset = Links.change_link(link)
    render(conn, "edit.html", link: link, changeset: changeset)
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    link = Links.get_link!(id)

    case Links.update_link(link, link_params) do
      {:ok, link} ->
        conn
        |> put_flash(:info, "Link updated successfully.")
        |> redirect(to: link_path(conn, :show, link))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", link: link, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    link = Links.get_link!(id)
    {:ok, _link} = Links.delete_link(link)

    conn
    |> put_flash(:info, "Link deleted successfully.")
    |> redirect(to: link_path(conn, :index))
  end
end
