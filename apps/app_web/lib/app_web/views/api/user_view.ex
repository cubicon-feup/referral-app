defmodule AppWeb.Api.UserView do
  use AppWeb, :view
  alias AppWeb.Api.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      date_of_birth: user.date_of_birth,
      email: user.email,
      name: user.name,
      password: user.password,
      picture_path: user.picture_path,
      privileges_level: user.privileges_level,
      deleted: user.deleted}
  end
end
