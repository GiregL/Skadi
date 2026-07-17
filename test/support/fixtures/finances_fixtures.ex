defmodule Skadi.FinancesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Skadi.Finances` context.
  """

  @doc """
  Generate a movement.
  """
  def movement_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        date: ~D[2026-07-16],
        destination: "some destination",
        direction: :income,
        notes: "some notes",
        source: "some source"
      })

    {:ok, movement} = Skadi.Finances.create_movement(scope, attrs)
    movement
  end
end
