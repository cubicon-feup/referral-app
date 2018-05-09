defmodule AppWeb.PaymentView do
  use AppWeb, :view

  alias App.Payments
  
  def get_changeset(payment) do
    Payments.change_payment(payment)
  end

  def format_date(date) do
    #date.year <> "/" <> date.month <> "/" <> date.day
    Enum.join [date.year, date.month, date.day], "/"
  end

  def format_reward(reward) do
    case reward do
      "money" ->
        "Cash"
      "voucher" ->
        "Voucher"
      "products" ->
        "In Kind"
    end
  end

end
