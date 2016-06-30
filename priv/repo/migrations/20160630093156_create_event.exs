defmodule Churchspace.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
