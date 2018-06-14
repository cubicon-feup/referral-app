defmodule AppWeb.ContractView do
  use AppWeb, :view

  alias App.Vouchers
  alias App.Contracts
  alias App.Contracts.Contract

  Decimal.set_context(%Decimal.Context{Decimal.get_context() | precision: 4})

  def get_brands(%Contract{} = contract) do
    case Contracts.get_brands(contract) do
      {:ok, brands} ->
        brands
        |> Enum.map(fn brand -> brand.name end)
        |> Enum.join(", ")

      {:error, _} ->
        nil
    end
  end

  def get_pending(%Contract{} = contract) do
    Contracts.get_payments(contract)
    |> Enum.reduce(0.0, fn p, acc ->
      if p.status == "pending" do
        acc + Decimal.to_float(p.value)
      else
        acc
      end
    end)
    |> Float.round(2)
    |> :erlang.float_to_binary(decimals: 2)
  end

  def get_rewarded(%Contract{} = contract) do
    Contracts.get_payments(contract)
    |> Enum.reduce(0.0, fn p, acc ->
      if p.status == "complete" do
        acc + Decimal.to_float(p.value)
      else
        acc
      end
    end)
    |> Float.round(2)
    |> :erlang.float_to_binary(decimals: 2)
  end

  def get_payments(%Contract{} = contract) do
    Contracts.get_payments(contract)
  end

  def get_vouchers(%Contract{} = contract) do
    Vouchers.get_vouchers_by_contract!(contract.id)
  end

  def get_sales(%Contract{} = contract) do
    Contracts.get_number_of_sales(contract.id)
  end

  def get_customers(%Contract{} = contract) do
    Contracts.get_contract_customers(contract.id)
    |> Enum.uniq()
    |> Enum.count()
  end

  def get_revenue(%Contract{} = contract) do
    Contracts.get_total_contract_revenue(contract.id)
    |> Decimal.round(2)
  end

  def get_sessions(%Contract{} = contract) do
    Contracts.get_total_contract_views(contract.id)
  end

  def get_aov(%Contract{} = contract) do
    case Decimal.equal?(get_revenue(contract), 0) do
      true ->
        Decimal.new(0.00)
        |> Decimal.round(2)

      false ->
        Decimal.div(get_revenue(contract), get_sales(contract))
        |> Decimal.round(2)
    end
  end

  def get_vcr(%Contract{} = contract) do
    case Decimal.equal?(get_sessions(contract), 0) do
      true ->
        0

      false ->
        Decimal.div(get_sessions(contract), get_customers(contract))
        |> Decimal.mult(100)
    end
  end

  def get_rpv(%Contract{} = contract) do
    Decimal.mult(get_aov(contract), get_vcr(contract))
  end

  def get_cac(%Contract{} = contract) do
    Decimal.mult(get_rewarded(contract), get_customers(contract))
  end

  def get_sps(%Contract{} = contract) do
    case Decimal.equal?(get_sessions(contract), 0) do
      true ->
        0

      false ->
        Decimal.div(get_sessions(contract), get_sales(contract))
    end
  end

  def format_date(date) do
    Enum.join([date.year, date.month, date.day], "/")
  end
end
