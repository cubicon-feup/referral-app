defmodule AppWeb.UserView do
  use AppWeb, :view
  alias AppWeb.UserView

  def render("index.json", %{user: user}) do
    %{data: render_many(user, UserView, "user.json")}
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
      priveleges_level: user.priveleges_level,
      deleted: user.deleted}
  end
end
