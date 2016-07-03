defmodule Churchspace.Category do
  use Churchspace.Web, :model

  schema "categories" do
    field :title, :string
    field :description, :string
    belongs_to :event, Churchspace.Event
    has_many :posts, Churchspace.Post

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

  def alphabetical(query) do
    from c in query, order_by: c.title
  end

  def for_event(query, nil) do
    from c in query, where: is_nil(c.event_id)
  end

  def for_event(query, id) do
    from c in query, where: c.event_id == ^id
  end

  def titles_and_ids(query) do
    from c in query, select: {c.title, c.id}
  end
end
