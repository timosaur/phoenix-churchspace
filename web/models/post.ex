defmodule Churchspace.Post do
  use Churchspace.Web, :model

  @required_fields ~w(title)a
  @optional_fields ~w(body parent_id)a

  schema "posts" do
    field :title, :string
    field :body, :string
    belongs_to :event, Churchspace.Event
    belongs_to :parent, Churchspace.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
  end

  def for_event(query, nil) do
    from p in query, where: is_nil(p.event_id)
  end

  def for_event(query, id) do
    from p in query, where: p.event_id == ^id
  end

  def titles_and_ids(query) do
    from p in query, select: {p.title, p.id}
  end
end
