defmodule AppWeb.WebhookController do
  use AppWeb, :controller

  def handleData(conn, params) do
    # IO.inspect(conn)    
    send_resp(conn, 200, "ok")
  end
end
