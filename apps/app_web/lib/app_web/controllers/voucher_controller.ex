defmodule AppWeb.VoucherController do
  use AppWeb, :controller
  plug :assign_contract
  alias App.Vouchers
  alias App.Vouchers.Voucher
  alias App.Contracts
  alias App.Repo



def get_rules(contract_id, voucher) do
  contract = Contracts.get_contract!(contract_id)

  base_url = "https://" <> contract.brand.api_key <>":"<>contract.brand.api_password<>"@"<>contract.brand.hostname
  url = base_url<>"/admin/discount_codes/lookup.json?code="<>voucher.code
  case HTTPoison.get(url) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
      #IO.inspect body, label: "response:"
    {:ok, %HTTPoison.Response{status_code: 404}} ->
      #IO.puts "Not found :("
    {:ok, %HTTPoison.Response{status_code: 303, headers: headers}} ->
        price_rule_id = List.keyfind(headers, "Location", 0)
        |> elem(1)
        |> String.split("/", trim: true)
        |> Enum.at(4,nil)
        case HTTPoison.get(base_url<>"/admin/price_rules/#{price_rule_id}.json") do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            price_rule = Poison.Parser.parse!(body)
            |> get_in(["price_rule"])
            #price_rule = Poison.decode!(body)
          {:ok, %HTTPoison.Response{status_code: 404}} ->
           #IO.puts "Not found :("
        end
        discount_code_id = List.keyfind(headers, "Location", 0)
        |> elem(1)
        |> String.split("/", trim: true)
        |> Enum.at(6,nil)
        case HTTPoison.get(base_url<>"/admin/price_rules/#{price_rule_id}/discount_codes/#{discount_code_id}.json") do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            discount_code = Poison.Parser.parse!(body)
            |> get_in(["discount_code"])
          {:ok, %HTTPoison.Response{status_code: 404}} ->
           IO.puts "Not found :("
        end

      #IO.inspect   [price_rule, discount_code]
    {:error, %HTTPoison.Error{reason: reason}} ->
      #IO.inspect "Media: #{reason}!"
  end
end


  def index(conn, %{"contract_id" => contract_id}) do
    case  Vouchers.get_voucher_by_contract!(contract_id) do
      {:ok, voucher} ->
      rules = get_rules(contract_id,voucher)
        #devo fazer o get aqui ou na View?
        render(conn, "show.html", voucher: voucher, price_rule: Enum.at(rules, 0))
        {:error, _} ->
          conn
          |> put_flash(:info, "There is no voucher associated with this contract.")
          |> redirect(to: contract_voucher_path(conn, :new, contract_id))
        end
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


              url = "https://e1c4afd5632958dd66626a3257ac72d7:b36782cbdc2d7991f2c804bcd63a9246@duarte-store-29.myshopify.com/admin/price_rules/"
              <> voucher_params["price_rule_id"] <> "/discount_codes.json"

              body = "{
                \"discount_code\": {
                  \"code\": \"FREESHIPPINGPOST\"
                }
              }"
                  #IO.inspect body, label: "PARAMS:!!!!!"
                  headers = [{"Content-type", "application/json"}]

                  case HTTPoison.post(url, body, headers, []) do
                    {:ok, response} ->
                      #O.inspect "Media: OK!"
                    {:error, %HTTPoison.Error{reason: reason}} ->
                      #IO.inspect "Media: #{reason}!"
                  end









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

                      defp post_voucher(conn, %{"voucher" => voucher_params , "price_rule_id" => price_rule_id}) do
                        changeset = conn.assigns[:contract]
                        |> Ecto.build_assoc(:voucher)
                        #IO.inspect(price_rule_id, "Rule::::")

                        case Vouchers.create_voucher(voucher_params) do
                          {:ok, _voucher} ->
                            conn
                            |> put_flash(:info, "Voucher created successfully.")
                            |> redirect(to: contract_voucher_path(conn, :index, conn.assigns[:contract]))
                            {:error, %Ecto.Changeset{} = changeset} ->
                              render(conn, "new.html", changeset: changeset)
                            end
                          end

                        end
