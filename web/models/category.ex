defmodule Churchspace.Category do
  use Churchspace.Web, :model

  schema "categories" do
    field :title, :string
    field :description, :string
    belongs_to :event, Churchspace.Event

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description])
    |> validate_required([:title, :description])
  end
end
