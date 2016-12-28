defmodule Discuss.TopicController do
  alias Discuss.Topic

  use Discuss.Web, :controller

  # GET /topics
  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  # GET /topics/:id
  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)

    render conn, "show.html", topic: topic
  end

  # GET /topics/new
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{})
    render conn, "new.html", changeset: changeset
  end

  # POST /topics
  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic successfully created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Cannot save topic")
        |> render "new.html", changeset: changeset
    end
  end

  # GET /topics/:id/edit
  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

   def update(conn, %{"id" => topic_id, "topic" => topic_params}) do
     old_topic = Repo.get(Topic, topic_id)
     changeset = Topic.changeset(old_topic, topic_params)

     case Repo.update(changeset) do
        {:ok, _topic} ->
          conn
            |> put_flash(:info, "Topic successfully updated")
            |> redirect to: topic_path(conn, :index)
        {:error, changeset} ->
          conn
            |> put_flash(:error, "Cannot save topic")
            |> render "edit.html", changeset: changeset, topic: old_topic
     end
   end

    def delete(conn, %{"id" => topic_id}) do
      Repo.get!(Topic, topic_id) |> Repo.delete!

      conn
        |> put_flash(:info, "Topic successfully deleted")
        |> redirect to: topic_path(conn, :index)
    end
end