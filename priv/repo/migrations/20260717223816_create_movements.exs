defmodule Skadi.Repo.Migrations.CreateMovements do
  use Ecto.Migration

  def change do
    create table(:movements) do
      add :direction, :string
      add :source, :string
      add :destination, :string
      add :notes, :text
      add :date, :date
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:movements, [:user_id])
  end
end
