defmodule Churchspace.Repo.Migrations.AddSortIndexToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :sort_index, :integer
    end
  end
end
