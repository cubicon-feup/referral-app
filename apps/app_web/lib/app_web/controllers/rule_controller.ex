defmodule AppWeb.RuleController do
  use AppWeb, :controller

  alias App.Rules
  alias App.Rules.Rule

  def index(conn, _params) do
    rules = Rules.list_rules()
    render(conn, "index.html", rules: rules)
  end

  def new(conn, _params) do
    changeset = Rules.change_rule(%Rule{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"rule" => rule_params}) do
    case Rules.create_rule(rule_params) do
      {:ok, rule} ->
        conn
        |> put_flash(:info, "Rule created successfully.")
        |> redirect(to: rule_path(conn, :show, rule))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rule = Rules.get_rule!(id)
    render(conn, "show.html", rule: rule)
  end

  def edit(conn, %{"id" => id}) do
    rule = Rules.get_rule!(id)
    changeset = Rules.change_rule(rule)
    render(conn, "edit.html", rule: rule, changeset: changeset)
  end

  def update(conn, %{"id" => id, "rule" => rule_params}) do
    rule = Rules.get_rule!(id)

    case Rules.update_rule(rule, rule_params) do
      {:ok, rule} ->
        conn
        |> put_flash(:info, "Rule updated successfully.")
        |> redirect(to: rule_path(conn, :show, rule))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", rule: rule, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rule = Rules.get_rule!(id)
    {:ok, _rule} = Rules.delete_rule(rule)

    conn
    |> put_flash(:info, "Rule deleted successfully.")
    |> redirect(to: rule_path(conn, :index))
  end
end
