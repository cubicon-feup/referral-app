defmodule AppWeb.ContractView do
  use AppWeb, :view

  alias App.Vouchers
  alias App.Contracts
  alias App.Contracts.Contract

  def get_brands(%Contract{} = contract) do
    Contracts.get_brands(contract)
    |> Enum.map( fn brand -> brand.name end)
    |> Enum.join(", ")   
  end

  def get_pending(%Contract{} = contract) do
    Contracts.get_payments(contract)
    |> Enum.reduce( 0.0, fn (p, acc) ->
      if p.status == "pending" do
        acc +  Decimal.to_float(p.value)
      else
        acc
      end
    end)
    |> Float.round(2)
    |> :erlang.float_to_binary([decimals: 2])
  end

  def get_rewarded(%Contract{} = contract) do
    Contracts.get_payments(contract)
    |> Enum.reduce( 0.0, fn (p, acc) ->
      if p.status == "complete" do
        acc +  Decimal.to_float(p.value)
      else
        acc
      end
    end)
    |> Float.round(2)
    |> :erlang.float_to_binary([decimals: 2])
  end

  def get_payments(%Contract{} = contract) do
    Contracts.get_payments(contract)
  end

  def get_vouchers(%Contract{} = contract) do
    Vouchers.get_vouchers_by_contract!(contract.id)
  end


  def format_date(date) do
    #date.year <> "/" <> date.month <> "/" <> date.day
    Enum.join [date.year, date.month, date.day], "/"
  end
end
