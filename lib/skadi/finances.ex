defmodule Skadi.Finances do
  @moduledoc """
  The Finances context.
  """

  import Ecto.Query, warn: false
  alias Skadi.Repo

  alias Skadi.Finances.Movement
  alias Skadi.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any movement changes.

  The broadcasted messages match the pattern:

    * {:created, %Movement{}}
    * {:updated, %Movement{}}
    * {:deleted, %Movement{}}

  """
  def subscribe_movements(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Skadi.PubSub, "user:#{key}:movements")
  end

  defp broadcast_movement(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Skadi.PubSub, "user:#{key}:movements", message)
  end

  @doc """
  Returns the list of movements.

  ## Examples

      iex> list_movements(scope)
      [%Movement{}, ...]

  """
  def list_movements(%Scope{} = scope) do
    Repo.all_by(Movement, user_id: scope.user.id)
  end

  @doc """
  Gets a single movement.

  Raises `Ecto.NoResultsError` if the Movement does not exist.

  ## Examples

      iex> get_movement!(scope, 123)
      %Movement{}

      iex> get_movement!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_movement!(%Scope{} = scope, id) do
    Repo.get_by!(Movement, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a movement.

  ## Examples

      iex> create_movement(scope, %{field: value})
      {:ok, %Movement{}}

      iex> create_movement(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_movement(%Scope{} = scope, attrs) do
    with {:ok, movement = %Movement{}} <-
           %Movement{}
           |> Movement.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_movement(scope, {:created, movement})
      {:ok, movement}
    end
  end

  @doc """
  Updates a movement.

  ## Examples

      iex> update_movement(scope, movement, %{field: new_value})
      {:ok, %Movement{}}

      iex> update_movement(scope, movement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_movement(%Scope{} = scope, %Movement{} = movement, attrs) do
    true = movement.user_id == scope.user.id

    with {:ok, movement = %Movement{}} <-
           movement
           |> Movement.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_movement(scope, {:updated, movement})
      {:ok, movement}
    end
  end

  @doc """
  Deletes a movement.

  ## Examples

      iex> delete_movement(scope, movement)
      {:ok, %Movement{}}

      iex> delete_movement(scope, movement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_movement(%Scope{} = scope, %Movement{} = movement) do
    true = movement.user_id == scope.user.id

    with {:ok, movement = %Movement{}} <-
           Repo.delete(movement) do
      broadcast_movement(scope, {:deleted, movement})
      {:ok, movement}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking movement changes.

  ## Examples

      iex> change_movement(scope, movement)
      %Ecto.Changeset{data: %Movement{}}

  """
  def change_movement(%Scope{} = scope, %Movement{} = movement, attrs \\ %{}) do
    true = movement.user_id == scope.user.id

    Movement.changeset(movement, attrs, scope)
  end
end
