defmodule AppWeb.VoucherController do
  use AppWeb, :controller
  plug(:assign_contract)
  alias App.Vouchers
  alias App.Vouchers.Voucher
  alias App.Contracts
  alias App.Repo
  alias App.Brands

  def build_url(contract_id) do
    contract = Contracts.get_contract!(contract_id)

    base_url =
      "https://" <>
        contract.brand.api_key <>
        ":" <> contract.brand.api_password <> "@" <> contract.brand.hostname
  end

  def lookup_voucher(voucher) do
    url =
      build_url(voucher.contract_id) <> "/admin/discount_codes/lookup.json?code=" <> voucher.code

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:error, "200"}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "404"}

      {:ok, %HTTPoison.Response{status_code: 303, headers: headers}} ->
        location =
          List.keyfind(headers, "Location", 0)
          |> elem(1)

        {:ok, location}
    end
  end

  def get_rules_id(voucher) do
    case lookup_voucher(voucher) do
      {:ok, location} ->
        split = String.split(location, "/", trim: true)

        {:ok, %{:price_rule_id => Enum.at(split, 4, nil), :voucher_id => Enum.at(split, 6, nil)}}

      {:error, error} ->
        #IO.inspect(error)
        error
    end
  end

  def index(conn, %{"contract_id" => contract_id}) do
    vouchers = Vouchers.get_vouchers_by_contract!(contract_id)
    render(conn, "index.html", vouchers: vouchers)
  end

  def new(conn, _params) do
    changeset = Vouchers.change_voucher(%Voucher{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"voucher" => voucher_params}) do
    contract = conn.assigns.contract

    price_rule_id = Map.get(voucher_params, "price_rule_id", nil)
    voucher_params = Map.put(voucher_params, "contract_id", contract.id)
    brand_id = Plug.Conn.get_session(conn, :brand_id)
    post_discount(voucher_params["code"], price_rule_id, brand_id)

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
    case Vouchers.get_voucher!(id) do
      {:ok, voucher} ->
        case get_rules_id(voucher) do
          {:ok, %{:price_rule_id => price_rule_id, :voucher_id => voucher_id}} ->
            render(
              conn,
              "show.html",
              voucher: voucher,
              price_rule_id: price_rule_id,
              voucher_id: voucher_id
            )

          {:error, _} ->
            conn
            |> put_flash(:info, "There is no voucher associated with this contract.")
            |> redirect(to: contract_voucher_path(conn, :new, id))
        end

      {:error, _} ->
        conn
        |> put_flash(:info, "There is no voucher associated with this contract.")
        |> redirect(to: contract_voucher_path(conn, :new, id))
    end
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

      _ ->
        invalid_contract(conn)
    end
  end

  defp invalid_contract(conn) do
    conn
    |> put_flash(:error, "Invalid contract!")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end

  def post_discount(voucher_code, price_rule_id, brand_id) do
    brand = Brands.get_brand!(brand_id)

    base_url = "https://" <> brand.api_key <> ":" <> brand.api_password <> "@" <> brand.hostname

    url = base_url <> "/admin/price_rules/#{price_rule_id}/discount_codes.json"

    header =
      "{\"discount_code\": {\"code\": \"#{voucher_code}\" }}"
      #|> IO.inspect()

    case HTTPoison.post(url, "{\"discount_code\": {\"code\": \"#{voucher_code}\" }}", [
           {"Content-Type", "application/json"}
         ]) do
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        #IO.inspect(body)
        body
      {:ok, %HTTPoison.Response{status_code: 422, body: body}} ->
        # code already exists
        #IO.inspect(body)
        body
      {:error, %HTTPoison.Error{reason: reason}} ->
        #IO.inspect(reason, label: "erro:")
        reason
    end
  end
end
