defmodule AppWeb.ContractController do
  use AppWeb, :controller

  alias App.Contracts
  alias App.Contracts.Contract
  alias App.Vouchers
  alias App.Vouchers.Voucher


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
end
