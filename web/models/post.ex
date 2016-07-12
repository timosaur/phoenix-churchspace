defmodule Churchspace.Post do
  use Churchspace.Web, :model

  @required_fields ~w(title)a
  @optional_fields ~w(body is_category parent_id)a

  schema "posts" do
    field :title, :string
    field :body, :string
    field :is_category, :boolean
    field :sort_index, :integer
    belongs_to :event, Churchspace.Event
    belongs_to :parent, Churchspace.Post

    has_one :next_post, Churchspace.Post
    has_one :prev_post, Churchspace.Post

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

  def categories(query) do
    from p in query, where: p.is_category
  end

  def for_event(query, nil) do
    from p in query, where: is_nil(p.event_id)
  end

  def for_event(query, id) do
    from p in query, where: p.event_id == ^id
  end

  def for_parent(query, nil) do
    from p in query, where: is_nil(p.parent_id)
  end

  def for_parent(query, id) do
    from p in query, where: p.parent_id == ^id
  end

  def alphabetical(query) do
    from p in query, order_by: p.title
  end

  def newest_created(query) do
    from p in query, order_by: [desc: p.inserted_at]
  end

  def oldest_created(query) do
    from p in query, order_by: p.inserted_at
  end

  def sorted_by_index(query) do
    from p in query, order_by: p.sort_index
  end

  def titles_and_ids(query) do
    from p in query, select: {p.title, p.id}
  end
end
