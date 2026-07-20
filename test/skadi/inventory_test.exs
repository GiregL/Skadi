defmodule Skadi.InventoryTest do
  use Skadi.DataCase

  alias Skadi.Inventory

  describe "services" do
    alias Skadi.Inventory.Service

    import Skadi.AccountsFixtures, only: [user_scope_fixture: 0]
    import Skadi.InventoryFixtures

    @invalid_attrs %{name: nil, amount: nil, starting_date: nil, frequency: nil}

    test "list_services/1 returns all scoped services" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      service = service_fixture(scope)
      other_service = service_fixture(other_scope)
      assert Inventory.list_services(scope) == [service]
      assert Inventory.list_services(other_scope) == [other_service]
    end

    test "get_service!/2 returns the service with given id" do
      scope = user_scope_fixture()
      service = service_fixture(scope)
      other_scope = user_scope_fixture()
      assert Inventory.get_service!(scope, service.id) == service
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_service!(other_scope, service.id) end
    end

    test "create_service/2 with valid data creates a service" do
      valid_attrs = %{name: "some name", amount: "120.5", starting_date: ~D[2026-07-19], frequency: :daily}
      scope = user_scope_fixture()

      assert {:ok, %Service{} = service} = Inventory.create_service(scope, valid_attrs)
      assert service.name == "some name"
      assert service.amount == Decimal.new("120.5")
      assert service.starting_date == ~D[2026-07-19]
      assert service.frequency == :daily
      assert service.user_id == scope.user.id
    end

    test "create_service/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.create_service(scope, @invalid_attrs)
    end

    test "update_service/3 with valid data updates the service" do
      scope = user_scope_fixture()
      service = service_fixture(scope)
      update_attrs = %{name: "some updated name", amount: "456.7", starting_date: ~D[2026-07-20], frequency: :weekly}

      assert {:ok, %Service{} = service} = Inventory.update_service(scope, service, update_attrs)
      assert service.name == "some updated name"
      assert service.amount == Decimal.new("456.7")
      assert service.starting_date == ~D[2026-07-20]
      assert service.frequency == :weekly
    end

    test "update_service/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      service = service_fixture(scope)

      assert_raise MatchError, fn ->
        Inventory.update_service(other_scope, service, %{})
      end
    end

    test "update_service/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      service = service_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Inventory.update_service(scope, service, @invalid_attrs)
      assert service == Inventory.get_service!(scope, service.id)
    end

    test "delete_service/2 deletes the service" do
      scope = user_scope_fixture()
      service = service_fixture(scope)
      assert {:ok, %Service{}} = Inventory.delete_service(scope, service)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_service!(scope, service.id) end
    end

    test "delete_service/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      service = service_fixture(scope)
      assert_raise MatchError, fn -> Inventory.delete_service(other_scope, service) end
    end

    test "change_service/2 returns a service changeset" do
      scope = user_scope_fixture()
      service = service_fixture(scope)
      assert %Ecto.Changeset{} = Inventory.change_service(scope, service)
    end
  end
end
