defmodule Skadi.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Skadi.Inventory` context.
  """

  @doc """
  Generate a service.
  """
  def service_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        amount: "120.5",
        frequency: :daily,
        name: "some name",
        starting_date: ~D[2026-07-19]
      })

    {:ok, service} = Skadi.Inventory.create_service(scope, attrs)
    service
  end
end
