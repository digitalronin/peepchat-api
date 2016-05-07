defmodule Peepchat.RegistrationController do
  use Peepchat.Web, :controller

  alias Peepchat.{User, UserView, ChangesetView}

  def create(conn, %{"data" => %{"type" => "user",
     "attributes" => %{
       "email"                 => email,
       "password"              => password,
       "password_confirmation" => password_confirmation }
    }}) do

    changeset = User.changeset %User{}, %{email: email,
     password_confirmation: password_confirmation,
     password: password
   }

   case Repo.insert changeset do
     {:ok, user} ->
       conn
       |> put_status(:created)
       |> render(UserView, "show.json", user: user)

     {:error, changeset} ->
       conn
       |> put_status(:unprocessable_entity)
       |> render(ChangesetView, "error.json", changeset: changeset)
   end
  end

end