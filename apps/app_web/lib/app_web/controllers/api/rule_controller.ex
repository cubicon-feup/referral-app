defmodule AppWeb.Api.RuleController do
  use AppWeb, :controller

  alias App.Rules
  alias App.Rules.Rule

  action_fallback AppWeb.FallbackController

  def index(conn, _params) do
    rules = Rules.list_rules()
    render(conn, "index.json", rules: rules)
  end

  def create(conn, %{"rule" => rule_params}) do
    with {:ok, %Rule{} = rule} <- Rules.create_rule(rule_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_rule_path(conn, :show, rule))
      |> render("show.json", rule: rule)
    end
  end

  def show(conn, %{"id" => id}) do
    rule = Rules.get_rule!(id)
    render(conn, "show.json", rule: rule)
  end

  def update(conn, %{"id" => id, "rule" => rule_params}) do
    rule = Rules.get_rule!(id)

    with {:ok, %Rule{} = rule} <- Rules.update_rule(rule, rule_params) do
      render(conn, "show.json", rule: rule)
    end
  end

  def delete(conn, %{"id" => id}) do
    rule = Rules.get_rule!(id)
    with {:ok, %Rule{}} <- Rules.delete_rule(rule) do
      send_resp(conn, :no_content, "")
    end
  end
end
