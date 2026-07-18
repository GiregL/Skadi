defmodule Skadi.Finances.Movement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movements" do
    field :direction, Ecto.Enum, values: [:income, :expense]
    field :source, :string
    field :destination, :string
    field :notes, :string
    field :date, :date
    field :amount, :decimal
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(movement, attrs, user_scope) do
    movement
    |> cast(attrs, [:direction, :source, :destination, :notes, :date, :amount])
    |> validate_required([:direction, :source, :destination, :notes, :date, :amount])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> put_change(:user_id, user_scope.user.id)
  end
end
