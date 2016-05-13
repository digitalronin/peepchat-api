defmodule Peepchat.UserController do
  use Peepchat.Web, :controller

  alias Peepchat.{Repo, User, UserView, AuthErrorHandler}

  plug Guardian.Plug.EnsureAuthenticated, handler: AuthErrorHandler

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", data: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", data: user)
  end

  def current(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, UserView, "show.json", data: user)
  end

end
