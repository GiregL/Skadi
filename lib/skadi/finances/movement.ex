defmodule Skadi.Finances.Movement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movements" do
    field :direction, Ecto.Enum, values: [:income, :expense]
    field :source, :string
    field :destination, :string
    field :notes, :string
    field :date, :date
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(movement, attrs, user_scope) do
    movement
    |> cast(attrs, [:direction, :source, :destination, :notes, :date])
    |> validate_required([:direction, :source, :destination, :notes, :date])
    |> put_change(:user_id, user_scope.user.id)
  end
end
