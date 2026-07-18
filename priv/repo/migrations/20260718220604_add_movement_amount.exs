defmodule Skadi.Repo.Migrations.AddMovementAmount do
  use Ecto.Migration

  def change do
    alter table(:movements) do
      add :amount, :decimal, precision: 10, scale: 2
    end
  end
end
