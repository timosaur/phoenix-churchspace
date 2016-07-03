defmodule Churchspace.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :title, :string
      add :description, :string

      add :event_id, references(:events)
      timestamps()
    end

  end
end
