defmodule Skadi.Inventory.Service do
  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :name, :string
    field :amount, :decimal
    field :starting_date, :date
    field :frequency, Ecto.Enum, values: [:daily, :weekly, :monthly, :yearly], default: :monthly
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(service, attrs, user_scope) do
    service
    |> cast(attrs, [:name, :amount, :starting_date, :frequency])
    |> validate_required([:name, :amount, :starting_date, :frequency])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> put_change(:user_id, user_scope.user.id)
  end
end
