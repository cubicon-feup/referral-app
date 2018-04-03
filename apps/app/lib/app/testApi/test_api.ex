defmodule App.TestApi do
    use AppWeb, :controller
  
    def test(conn, _params) do
      json conn, %{test: "well done!"}
    end
  end
  