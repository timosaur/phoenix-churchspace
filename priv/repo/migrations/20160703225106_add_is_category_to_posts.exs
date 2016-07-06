defmodule Churchspace.Repo.Migrations.AddIsCategoryToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :is_category, :boolean
    end
  end
end
