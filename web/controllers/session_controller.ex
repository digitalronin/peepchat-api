defmodule Peepchat.SessionController do
  use Peepchat.Web, :controller

  import Ecto.Query, only: [where: 2]
  import Comeonin.Bcrypt

  require Logger

  alias Peepchat.{Repo, User}

  def create(conn, %{ "grant_type" => "password",
                      "username"   => username,
                      "password"   => password}) do
    try do
      user = User |> where(email: ^username) |> Repo.one!

      cond do
        checkpw(password, user.password_hash) ->
          Logger.info "User " <> username <> " logged in"
          {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)
          json(conn, %{access_token: jwt})

        true ->
          Logger.warn "User " <> username <> " failed to log in"
          conn
          |> put_status(401)
          |> render(Peepchat.ErrorView, "401.json") # 401
      end
    rescue
      e ->
        IO.inspect e # Print error to the console for debugging
        Logger.error "Unexpected error while attempting to login user " <> username
        conn
        |> put_status(401)
        |> render(Peepchat.ErrorView, "401.json") # 401
    end
  end

  def create(_conn, %{ "grant_type" => _ }) do
    throw "Unsupported grant_type"
  end
end
