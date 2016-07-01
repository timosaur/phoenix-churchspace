defmodule Churchspace.Event do
  use Churchspace.Web, :model

  schema "events" do
    field :name, :string
    field :description, :string
    has_many :posts, Churchspace.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
  end
end
