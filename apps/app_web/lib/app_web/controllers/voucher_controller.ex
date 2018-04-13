defmodule AppWeb.VoucherController do
  use AppWeb, :controller
  plug :assign_contract
  alias App.Vouchers
  alias App.Vouchers.Voucher
  alias App.Contracts.Contracts
  alias App.Repo


  def index(conn, %{"contract_id" => contract_id}) do
    #not sure if I should REPO
    voucher = Vouchers.get_voucher_by_contract!(contract_id)
    render(conn, "show.html", voucher: voucher)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:contract]
      |> Ecto.build_assoc(:voucher)
      |> Vouchers.change_voucher()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"voucher" => voucher_params}) do
    changeset = conn.assigns[:contract]
    |> Ecto.build_assoc(:voucher)

    case Vouchers.create_voucher(voucher_params) do
      {:ok, _voucher} ->
        conn
        |> put_flash(:info, "Voucher created successfully.")
        |> redirect(to: contract_voucher_path(conn, :index, conn.assigns[:contract]))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
        end
      end

      def show(conn, %{"id" => id}) do
        voucher = Repo.get!(Ecto.assoc(conn.assigns[:contract], :voucher), id)
        render(conn, "show.html", voucher: voucher)
      end

      def edit(conn, %{"id" => id}) do
        voucher = Repo.get!(Ecto.assoc(conn.assigns[:contract], :voucher), id)
        changeset = Vouchers.change_voucher(voucher)
        render(conn, "edit.html", voucher: voucher, changeset: changeset)
      end

      def update(conn, %{"id" => id, "voucher" => voucher_params}) do
        voucher = Vouchers.get_voucher!(id)
        case Vouchers.update_voucher(voucher, voucher_params) do
          {:ok, voucher} ->
            conn
            |> put_flash(:info, "Voucher updated successfully.")
            |> redirect(to: contract_voucher_path(conn, :show, conn.assigns[:contract], voucher))
            {:error, %Ecto.Changeset{} = changeset} ->
              render(conn, "edit.html", voucher: voucher, changeset: changeset)
            end
          end

          def delete(conn, %{"id" => id}) do
            voucher = Vouchers.get!(Ecto.assoc(conn.assigns[:contract], :voucher), id)
            {:ok, _voucher} = Vouchers.delete_voucher(voucher)

            conn
            |> put_flash(:info, "Voucher deleted successfully.")
            |> redirect(to: contract_voucher_path(conn, :index, conn.assigns[:contract]))
          end

          defp assign_contract(conn, _opts) do
            alias App.Contracts
            case conn.params do
              %{"contract_id" => contract_id} ->
                case Contracts.get_contract!(contract_id) do
                  nil -> invalid_contract(conn)
                  contract -> assign(conn, :contract, contract)
                end
              _ -> invalid_contract(conn)
              end
            end

            defp invalid_contract(conn) do
              conn
              |> put_flash(:error, "Invalid contract!")
              |> redirect(to: page_path(conn, :index))
              |> halt
            end

          end
