defmodule Skadi.Repo.Migrations.AddUserUsername do
  use Ecto.Migration

  @moduledoc """
  Migration that adds a username to the user table.
  """

  def change do
    alter table(:users) do
      add :username, :string, null: false
    end
  end
end
