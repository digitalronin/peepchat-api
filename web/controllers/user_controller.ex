defmodule Peepchat.UserController do
  use Peepchat.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: Peepchat.AuthErrorHandler

  def current(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, Peepchat.UserView, "show.json", user: user)
  end

end
