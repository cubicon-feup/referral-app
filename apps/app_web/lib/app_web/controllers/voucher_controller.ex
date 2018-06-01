defmodule AppWeb.VoucherController do
  use AppWeb, :controller
  plug(:assign_contract)
  plug(:scrub_params, "voucher" when action in [:create])
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
      build_url(voucher.contract.id) <> "/admin/discount_codes/lookup.json?code=" <> voucher.code

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
        # IO.inspect(error)
        error
    end
  end

  def index(conn, %{"contract_id" => contract_id}) do
    vouchers = Vouchers.get_vouchers_by_contract!(contract_id)
    render(conn, "index.html", vouchers: vouchers)
  end

  def new(conn, _params) do
    changeset = Vouchers.change_voucher(%Voucher{})
    brand_id = Plug.Conn.get_session(conn, :brand_id)
    render(conn, "new.html", changeset: changeset, brand_id: brand_id)
  end

  def create(conn, %{"voucher" => voucher_params}) do
    contract = conn.assigns.contract
    price_rule_id = Map.get(voucher_params, "price_rule", nil)
    voucher_params = Map.put(voucher_params, "contract_id", contract.id)
    brand_id = Plug.Conn.get_session(conn, :brand_id)
    IO.inspect(voucher_params)

    case voucher_params["add_price_rule"] do
      "true" ->
        case post_discount(voucher_params["code"], price_rule_id, brand_id) do
          {:ok, body} ->
            insert_voucher(conn, voucher_params)

          {:error, error} ->
            conn
            |> put_flash(:error, error)
            |> redirect(to: contract_voucher_path(conn, :new, contract.id))
        end

      "false" ->
        case create_price_rule(voucher_params, brand_id) do
          {:ok, _} ->
            insert_voucher(conn, voucher_params)

            conn
            |> put_flash(:info, "Voucher created successfully.")
            |> redirect(to: contract_voucher_path(conn, :index, conn.assigns[:contract]))
        end
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
        |> redirect(to: contract_voucher_path(conn, :show, conn.assigns[:contract], voucher.id))

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

    header = "{\"discount_code\": {\"code\": \"#{voucher_code}\" }}"
    # |> IO.inspect()

    case HTTPoison.post(url, "{\"discount_code\": {\"code\": \"#{voucher_code}\" }}", [
           {"Content-Type", "application/json"}
         ]) do
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 422, body: body}} ->
        # code already exists
        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def create_price_rule(voucher_params, brand_id) do
    brand = Brands.get_brand!(brand_id)

    base_url = "https://" <> brand.api_key <> ":" <> brand.api_password <> "@" <> brand.hostname

    url = base_url <> "/admin/price_rules.json"

    request = %{"title" => Map.get(voucher_params, "code", nil)}

    case Map.get(voucher_params, "discount_type", nil) do
      "free_shipping" ->
        request = Map.put(request, "value_type", "percentage")

        request =
          Map.put(
            request,
            "value",
            -100
          )

        request = Map.put(request, "allocation_method", "each")
        request = Map.put(request, "target_type", "shipping_line")
        request

      "percentage" ->
        request = Map.put(request, "value_type", "percentage")

        request =
          Map.put(
            request,
            "value",
            String.to_integer(Map.get(voucher_params, "discount_value", nil)) * -1
          )

        request = Map.put(request, "allocation_method", "across")
        request = Map.put(request, "target_type", "line_item")
        request

      "fixed_amount" ->
        request = Map.put(request, "value_type", "fixed_amount")

        request =
          Map.put(
            request,
            "value",
            String.to_integer(Map.get(voucher_params, "discount_value", nil)) * -1
          )

        request = Map.put(request, "allocation_method", "across")
        request = Map.put(request, "target_type", "line_item")
        request
    end

    request =
      Map.put(
        request,
        "customer_selection",
        "all"
      )

    request =
      Map.put(
        request,
        "target_selection",
        "all"
      )

    request =
      Map.put(
        request,
        "customer_selection",
        "all"
      )

    case Map.get(voucher_params, "minimun_amount", nil) != nil do
      true ->
        request =
          Map.put(request, "prerequisite_subtotal_range", %{
            "greater_than_or_equal_to" => Map.get(voucher_params, "minimun_amount", nil)
          })

      false ->
        nil
    end

    case Map.get(voucher_params, "minimun_items", nil) != nil do
      true ->
        request =
          Map.put(request, "prerequisite_quantity_range", %{
            "greater_than_or_equal_to" => Map.get(voucher_params, "minimun_items", nil)
          })

      false ->
        nil
    end

    case Map.get(voucher_params, "once_customer", nil) != nil do
      true ->
        request =
          Map.put(
            request,
            "once_per_customer",
            true
          )

      false ->
        nil
    end

    case Map.get(voucher_params, "usage_limit", nil) != nil do
      true ->
        request = Map.put(request, "usage_limit", Map.get(voucher_params, "usage_limit", nil))

      false ->
        nil
    end

    case build_time(voucher_params["start_date"], voucher_params["start_hour"]) do
      {:ok, start_time} ->
        request = Map.put(request, "starts_at", start_time)

      {:not, _} ->
        nil
    end

    case build_time(voucher_params["end_date"], voucher_params["end_hour"]) do
      {:ok, end_time} ->
        request = Map.put(request, "ends_at", end_time)

      {:not, _} ->
        nil
    end

    price_role = %{"price_rule" => request}

    IO.inspect(price_role, label: "reqiest")

    case HTTPoison.post(url, Poison.encode!(price_role), [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        parse =
          Poison.Parser.parse!(body)
          |> get_in(["price_rule"])

        post_discount(Map.get(voucher_params, "code", nil), parse["id"], brand_id)
    end
  end

  defp insert_voucher(conn, voucher_params) do
    case voucher_params["reward_type"] do
      "none" ->
        case Vouchers.create_voucher(%{
               "code" => voucher_params["code"],
               "contract_id" => voucher_params["contract_id"]
             }) do
          {:ok, voucher} ->
            #  IO.inspect(voucher)
            nil

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:info, "Voucher error.")

            render(conn, "new.html", changeset: changeset)
        end

      "sales" ->
        case Vouchers.create_voucher(%{
               "code" => voucher_params["code"],
               "points_on_sales" => voucher_params["points_on_sales"],
               "set_of_sales" => voucher_params["set_of_sales"],
               "contract_id" => voucher_params["contract_id"]
             }) do
          {:ok, voucher} ->
            # IO.inspect(voucher)
            nil

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:info, "Voucher error.")

            render(conn, "new.html", changeset: changeset)
        end

      "comission" ->
        case Vouchers.create_voucher(%{
               "code" => voucher_params["code"],
               "percent_on_sales" => voucher_params["percent_on_sales"],
               "contract_id" => voucher_params["contract_id"]
             }) do
          {:ok, voucher} ->
            # IO.inspect(voucher)
            nil

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:info, "Voucher error.")

            render(conn, "new.html", changeset: changeset)
        end

      "monthly" ->
        case Vouchers.create_voucher(%{
               "code" => voucher_params["code"],
               "points_per_month" => voucher_params["points_per_month"],
               "contract_id" => voucher_params["contract_id"]
             }) do
          {:ok, voucher} ->
            Johanna.every({732, :hr}, fn ->
              Contracts.add_points_2(
                voucher.contract.id,
                Decimal.to_float(voucher.points_per_month)
              )
            end)

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_flash(:info, "Voucher error.")

            render(conn, "new.html", changeset: changeset)
        end

        conn
        |> put_flash(:info, "Voucher created successfully.")
        |> redirect(to: contract_voucher_path(conn, :index, conn.assigns[:contract]))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:info, "Voucher error.")

        render(conn, "new.html", changeset: changeset)
    end
  end

  defp build_time(date, time) do
    case date == nil do
      true ->
        {:not, nil}

      false ->
        {:ok, date <> "T" <> time["hour"] <> ":" <> time["minute"] <> ":00Z"}
    end
  end
end
