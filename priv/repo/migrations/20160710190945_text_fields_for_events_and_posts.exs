defmodule Churchspace.Repo.Migrations.TextFieldsForEventsAndPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      modify :body, :text
    end
    alter table(:events) do
      modify :description, :text
    end
  end
end
