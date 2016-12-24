defmodule Discuss.Topic do
  use Discuss.Web, :model

  # Inform phoenix what's happen in the database
  schema "topics" do
    field :title, :string
  end

    # struct is the current object in the database
    # params is a hash with the key we want to update
    # return a changeset with errors
   def changeset(struct, params \\ %{}) do
     struct
     |> cast(params, [:title])  # struct goes through the pipe and return a changeset
     |> validate_required([:title])
   end

end