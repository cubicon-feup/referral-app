defmodule AppWeb.Api.PlanController do
  use AppWeb, :controller

  alias App.Plans
  alias App.Plans.Plan

  action_fallback AppWeb.FallbackController

  def index(conn, _params) do
    plans = Plans.list_plans()
    render(conn, "index.json", plans: plans)
  end

  def create(conn, %{"plan" => plan_params}) do
    with {:ok, %Plan{} = plan} <- Plans.create_plan(plan_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_plan_path(conn, :show, plan))
      |> render("show.json", plan: plan)
    end
  end

  def show(conn, %{"id" => id}) do
    plan = Plans.get_plan!(id)
    render(conn, "show.json", plan: plan)
  end

  def update(conn, %{"id" => id, "plan" => plan_params}) do
    plan = Plans.get_plan!(id)

    with {:ok, %Plan{} = plan} <- Plans.update_plan(plan, plan_params) do
      render(conn, "show.json", plan: plan)
    end
  end

  def delete(conn, %{"id" => id}) do
    plan = Plans.get_plan!(id)
    with {:ok, %Plan{}} <- Plans.delete_plan(plan) do
      send_resp(conn, :no_content, "")
    end
  end
end
