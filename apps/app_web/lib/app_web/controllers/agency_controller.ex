defmodule AppWeb.AgencyController do
  use AppWeb, :controller

  alias App.Agencies
  alias App.Agencies.Agency

  def index(conn, _params) do
    agencies = Agencies.list_agencies()
    render(conn, "index.html", agencies: agencies)
  end

  def new(conn, _params) do
    changeset = Agencies.change_agency(%Agency{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"agency" => agency_params}) do
    case Agencies.create_agency(agency_params) do
      {:ok, agency} ->
        conn
        |> put_flash(:info, "Agency created successfully.")
        |> redirect(to: agency_path(conn, :show, agency))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    agency = Agencies.get_agency!(id)
    render(conn, "show.html", agency: agency)
  end

  def edit(conn, %{"id" => id}) do
    agency = Agencies.get_agency!(id)
    changeset = Agencies.change_agency(agency)
    render(conn, "edit.html", agency: agency, changeset: changeset)
  end

  def update(conn, %{"id" => id, "agency" => agency_params}) do
    agency = Agencies.get_agency!(id)

    case Agencies.update_agency(agency, agency_params) do
      {:ok, agency} ->
        conn
        |> put_flash(:info, "Agency updated successfully.")
        |> redirect(to: agency_path(conn, :show, agency))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", agency: agency, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    agency = Agencies.get_agency!(id)
    {:ok, _agency} = Agencies.delete_agency(agency)

    conn
    |> put_flash(:info, "Agency deleted successfully.")
    |> redirect(to: agency_path(conn, :index))
  end
end
