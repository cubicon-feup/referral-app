defmodule AppWeb.ContractController do
  use AppWeb, :controller

  alias App.Contracts
  alias App.Contracts.Contract

  alias AppWeb.PageNotFoundController

  import AppWeb.Mailer

  def index(conn, _params) do
    contracts = Contracts.list_contracts()
    render(conn, "index.html", contracts: contracts)
  end

  def new(conn, _params) do
    changeset = Contracts.change_contract(%Contract{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"contract" => contract_params}) do
    case Contracts.create_contract(contract_params) do
      {:ok, contract} ->
        conn
        |> put_flash(:info, "Contract created successfully.")
        |> redirect(to: contract_path(conn, :show, contract))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    contract = Contracts.get_contract!(id)
    render(conn, "show.html", contract: contract)
  end

  def edit(conn, %{"id" => id}) do
    contract = Contracts.get_contract!(id)
    changeset = Contracts.change_contract(contract)
    render(conn, "edit.html", contract: contract, changeset: changeset)
  end

  def update(conn, %{"id" => id, "contract" => contract_params}) do
    contract = Contracts.get_contract!(id)

    case Contracts.update_contract(contract, contract_params) do
      {:ok, contract} ->
        conn
        |> put_flash(:info, "Contract updated successfully.")
        |> redirect(to: contract_path(conn, :show, contract))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", contract: contract, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contract = Contracts.get_contract!(id)
    {:ok, _contract} = Contracts.delete_contract(contract)

    conn
    |> put_flash(:info, "Contract deleted successfully.")
    |> redirect(to: contract_path(conn, :index))
  end


  def invite(conn, %{"id" => id}) do
    contract = Contracts.get_contract!(id)
    send_welcome_email(contract.contact, contract.name)

    conn
    |> put_flash(:info, gettext("Invite sent successfully"))
    |> redirect(to: contract_path(conn, :index))
  end

  def invited_contract(conn, %{"email" => email, "name" => name}) do
    case Guardian.Plug.current_resource(conn) do
      nil->
        conn
        |> put_flash(:info, "You need to be logged in to see this page")
        |> redirect(to: user_path(conn, :index))
      user->
        if user.email == email do
          case Contract.get_contract_by_email!(email) do
            nil->
              PageNotFoundController.error(conn, %{})
            contract->
              case Contracts.update_contract(contract, %{user_id: user.id}) do
                {:ok, contract} ->
                  conn
                  |> redirect(to: user_path(conn, :index))
                {:error, %Ecto.Changeset{} = changeset} ->
                  conn
                  |> PageNotFoundController.error(%{})
              end
          end
        else
          PageNotFoundController.error(conn, %{})
        end
    end
  end
end
