defmodule Churchspace.Repo.Migrations.AddEventFkeyToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :event_id, references(:events)
    end
  end
end
