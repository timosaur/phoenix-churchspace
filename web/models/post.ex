defmodule Churchspace.Post do
  use Churchspace.Web, :model

  @required_fields ~w(title)a
  @optional_fields ~w(body is_category sort_index parent_id)a

  schema "posts" do
    field :title, :string
    field :body, :string
    field :is_category, :boolean
    field :sort_index, :integer, default: 0
    field :parent_path, :string
    belongs_to :event, Churchspace.Event
    belongs_to :parent, __MODULE__

    field :sort_path, :string, virtual: true
    field :depth, :integer, virtual: true

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

  def sorted_event_posts(event_id) when is_integer(event_id) do
    qry = """
      WITH RECURSIVE tree AS
      (
        SELECT id, title, parent_id, event_id, parent_path::text,
               sort_index::text AS path
        FROM posts WHERE parent_id IS NULL
        AND event_id = $1
        UNION
        SELECT p.id, p.title, p.parent_id, p.event_id, p.parent_path::text,
               tree.path || '.' || p.sort_index::text AS path
        FROM tree
        JOIN posts p ON p.parent_id = tree.id
      )
      SELECT id, title, parent_id, event_id, parent_path::text,
             path AS sort_path, nlevel(text2ltree(path)) AS depth
      FROM tree
      ORDER BY path, title, id
      """
    %{qry: qry, params: [event_id]}
  end

  def sorted_event_posts(%Churchspace.Event{id: event_id}), do: sorted_event_posts(event_id)
  def sorted_event_posts(event_id), do: sorted_event_posts(String.to_integer(event_id))
end
