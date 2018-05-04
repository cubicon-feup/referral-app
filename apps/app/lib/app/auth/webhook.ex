defmodule App.Auth.Webhook do
  alias Plug

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    # FIX ME : in production needs to verify if the request cames from shopify

    # hash =
    #   Plug.Conn.get_req_header(conn, "x-shopify-hmac-sha256")
    #   |> List.first()
    #
    # secret_key = "153a97df2d7168c3c05b62c49ff83595763d9d11cff7e4bc3c37f88f8092698a"
    #
    # data = Poison.encode!(conn.body_params)
    #
    # hmac =
    #   :crypto.hmac(:sha256, secret_key, data)
    #   |> Base.encode64()

    conn
  end
end
