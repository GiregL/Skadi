defmodule Skadi.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :name, :string
      add :amount, :decimal
      add :starting_date, :date
      add :frequency, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:services, [:user_id])
  end
end
