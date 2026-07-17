defmodule Skadi.FinancesTest do
  use Skadi.DataCase

  alias Skadi.Finances

  describe "movements" do
    alias Skadi.Finances.Movement

    import Skadi.AccountsFixtures, only: [user_scope_fixture: 0]
    import Skadi.FinancesFixtures

    @invalid_attrs %{date: nil, source: nil, destination: nil, direction: nil, notes: nil}

    test "list_movements/1 returns all scoped movements" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      movement = movement_fixture(scope)
      other_movement = movement_fixture(other_scope)
      assert Finances.list_movements(scope) == [movement]
      assert Finances.list_movements(other_scope) == [other_movement]
    end

    test "get_movement!/2 returns the movement with given id" do
      scope = user_scope_fixture()
      movement = movement_fixture(scope)
      other_scope = user_scope_fixture()
      assert Finances.get_movement!(scope, movement.id) == movement
      assert_raise Ecto.NoResultsError, fn -> Finances.get_movement!(other_scope, movement.id) end
    end

    test "create_movement/2 with valid data creates a movement" do
      valid_attrs = %{date: ~D[2026-07-16], source: "some source", destination: "some destination", direction: :income, notes: "some notes"}
      scope = user_scope_fixture()

      assert {:ok, %Movement{} = movement} = Finances.create_movement(scope, valid_attrs)
      assert movement.date == ~D[2026-07-16]
      assert movement.source == "some source"
      assert movement.destination == "some destination"
      assert movement.direction == :income
      assert movement.notes == "some notes"
      assert movement.user_id == scope.user.id
    end

    test "create_movement/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Finances.create_movement(scope, @invalid_attrs)
    end

    test "update_movement/3 with valid data updates the movement" do
      scope = user_scope_fixture()
      movement = movement_fixture(scope)
      update_attrs = %{date: ~D[2026-07-17], source: "some updated source", destination: "some updated destination", direction: :expense, notes: "some updated notes"}

      assert {:ok, %Movement{} = movement} = Finances.update_movement(scope, movement, update_attrs)
      assert movement.date == ~D[2026-07-17]
      assert movement.source == "some updated source"
      assert movement.destination == "some updated destination"
      assert movement.direction == :expense
      assert movement.notes == "some updated notes"
    end

    test "update_movement/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      movement = movement_fixture(scope)

      assert_raise MatchError, fn ->
        Finances.update_movement(other_scope, movement, %{})
      end
    end

    test "update_movement/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      movement = movement_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Finances.update_movement(scope, movement, @invalid_attrs)
      assert movement == Finances.get_movement!(scope, movement.id)
    end

    test "delete_movement/2 deletes the movement" do
      scope = user_scope_fixture()
      movement = movement_fixture(scope)
      assert {:ok, %Movement{}} = Finances.delete_movement(scope, movement)
      assert_raise Ecto.NoResultsError, fn -> Finances.get_movement!(scope, movement.id) end
    end

    test "delete_movement/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      movement = movement_fixture(scope)
      assert_raise MatchError, fn -> Finances.delete_movement(other_scope, movement) end
    end

    test "change_movement/2 returns a movement changeset" do
      scope = user_scope_fixture()
      movement = movement_fixture(scope)
      assert %Ecto.Changeset{} = Finances.change_movement(scope, movement)
    end
  end
end
