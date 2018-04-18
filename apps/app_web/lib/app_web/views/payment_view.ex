defmodule AppWeb.PaymentView do
  use AppWeb, :view

  alias App.Payments
  
  def get_changeset(payment) do
    changeset = Payments.change_payment(payment)
  end

end
