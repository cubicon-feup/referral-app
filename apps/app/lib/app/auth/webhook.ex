defmodule App.Auth.Webhook do
  alias Plug

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    hash =
      Plug.Conn.get_req_header(conn, "x-shopify-hmac-sha256")
      |> List.first()
      |> IO.inspect()

    conn
  end
end
