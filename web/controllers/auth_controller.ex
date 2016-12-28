defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    alias Discuss.User
    plug Ueberauth

    # GET /auth/:provider/callback
    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
      user_params = %{ token: auth.credentials.token, email: auth.info.email, provider: "github" }
      changeset = User.changeset(%User{}, user_params)

      signin conn, changeset
    end

    # GET /auth/signout
    def signout(conn, _params) do
      conn
      |> configure_session(drop: true) # delete all session properties related to the current user
      |> redirect to: topic_path(conn, :index)
    end

    defp signin(conn, changeset) do
      case insert_or_update_user changeset do
        {:ok, user} ->
          conn
          |> put_flash(:info, "Welcome back!")
          |> put_session(:user_id, user.id)
          |> redirect to: topic_path(conn, :index)
        {:error, changeset} ->
          conn
          |> put_flash :error, "Cannot signin with Github, please retry later"
          |> redirect to: topic_path(conn, :index)
      end
    end

    defp insert_or_update_user(changeset) do
      case Repo.get_by(User, email: changeset.changes.email) do
        nil ->
          # We need to insert new record
          Repo.insert(changeset)
        user ->
          # No need to insert, return a tuple
          {:ok, user}
      end
    end

end