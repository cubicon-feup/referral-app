defmodule AppWeb.InfluencerView do
  use AppWeb, :view

  alias App.Influencers
  alias App.Influencers.Influencer
  alias App.Payments
  alias App.Vouchers
  alias App.Contracts.Contract
  
  def get_brands(%Influencer{} = influencer) do
    Influencers.get_brands(influencer.id)
    |> Enum.map( fn brand -> brand.name end)
    |> Enum.join(", ")   
  end

  def get_pending(%Influencer{} = influencer) do
    Payments.list_payments_influencer(influencer.id)
    |> Enum.reduce( 0, fn (p, acc) ->
      if p.status == "pending" do
        acc +  Decimal.to_float(p.value)
      else
        acc
      end
    end)
    |> Float.round(2)
    |> :erlang.float_to_binary([decimals: 2])
  end

  def get_rewarded(%Influencer{} = influencer) do
    Payments.list_payments_influencer(influencer.id)
    |> Enum.reduce( 0, fn (p, acc) ->
      if p.status == "complete" do
        acc +  Decimal.to_float(p.value)
      else
        acc
      end
    end)
    |> Float.round(2)
    |> :erlang.float_to_binary([decimals: 2])
  end

  def get_payments(%Influencer{} = influencer) do
    Payments.list_payments_influencer(influencer.id)
  end

  def get_vouchers(%Contract{} = contract) do
    Vouchers.get_vouchers_by_contract!(contract.id)
  end


  def format_date(date) do
    #date.year <> "/" <> date.month <> "/" <> date.day
    Enum.join [date.year, date.month, date.day], "/"
  end
end
