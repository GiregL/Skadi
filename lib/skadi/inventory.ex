defmodule Skadi.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias Skadi.Repo

  alias Skadi.Inventory.Service
  alias Skadi.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any service changes.

  The broadcasted messages match the pattern:

    * {:created, %Service{}}
    * {:updated, %Service{}}
    * {:deleted, %Service{}}

  """
  def subscribe_services(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Skadi.PubSub, "user:#{key}:services")
  end

  defp broadcast_service(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Skadi.PubSub, "user:#{key}:services", message)
  end

  @doc """
  Returns the list of services.

  ## Examples

      iex> list_services(scope)
      [%Service{}, ...]

  """
  def list_services(%Scope{} = scope) do
    Repo.all_by(Service, user_id: scope.user.id)
  end

  @doc """
  Gets a single service.

  Raises `Ecto.NoResultsError` if the Service does not exist.

  ## Examples

      iex> get_service!(scope, 123)
      %Service{}

      iex> get_service!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_service!(%Scope{} = scope, id) do
    Repo.get_by!(Service, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a service.

  ## Examples

      iex> create_service(scope, %{field: value})
      {:ok, %Service{}}

      iex> create_service(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_service(%Scope{} = scope, attrs) do
    with {:ok, service = %Service{}} <-
           %Service{}
           |> Service.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_service(scope, {:created, service})
      {:ok, service}
    end
  end

  @doc """
  Updates a service.

  ## Examples

      iex> update_service(scope, service, %{field: new_value})
      {:ok, %Service{}}

      iex> update_service(scope, service, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_service(%Scope{} = scope, %Service{} = service, attrs) do
    true = service.user_id == scope.user.id

    with {:ok, service = %Service{}} <-
           service
           |> Service.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_service(scope, {:updated, service})
      {:ok, service}
    end
  end

  @doc """
  Deletes a service.

  ## Examples

      iex> delete_service(scope, service)
      {:ok, %Service{}}

      iex> delete_service(scope, service)
      {:error, %Ecto.Changeset{}}

  """
  def delete_service(%Scope{} = scope, %Service{} = service) do
    true = service.user_id == scope.user.id

    with {:ok, service = %Service{}} <-
           Repo.delete(service) do
      broadcast_service(scope, {:deleted, service})
      {:ok, service}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking service changes.

  ## Examples

      iex> change_service(scope, service)
      %Ecto.Changeset{data: %Service{}}

  """
  def change_service(%Scope{} = scope, %Service{} = service, attrs \\ %{}) do
    true = service.user_id == scope.user.id

    Service.changeset(service, attrs, scope)
  end

  @doc """
  Computes the total of many services for the given frequency.
  Each frequency (yearly and all) are converted into the targetted frequency.
  """
  def compute_total_services(scope, frequency \\ :monthly) when is_struct(scope, Scope) and is_atom(frequency) do

  end

  @doc """
  Convert a service amount into the targetted frequency.
  Uses the current date or an execution date to keep the right amounts.

  ## Examples

    iex> service = %Service{amount: 31.0, frequency: :monthly}
    ...> convert_service_frequency(service, :daily, Date.new(2026, 01, 01))
    1.0
  """
  def convert_service_frequency(service, frequency, date \\ Date.utc_today())
  def convert_service_frequency(service, frequency, _) when service.frequency == frequency, do: service.amount
  def convert_service_frequency(service, frequency, date)
    when is_struct(service, Service) and is_atom(frequency) do

      amount_of_days_in_month = Date.days_in_month(date)
      amount_of_days_in_year = if :calendar.is_leap_year(date.year), do: 366, else: 365

      daily_amount =
        case service.frequency do
          :daily -> service.amount
          :weekly -> service.amount / 7
          :monthly -> service.amount / amount_of_days_in_month
          :yearly -> service.amount / amount_of_days_in_year
        end

      case frequency do
        :daily -> daily_amount
        :weekly -> daily_amount * 7
        :monthly -> service.amount * amount_of_days_in_month
        :yearly -> service.amount * amount_of_days_in_year
      end
  end
end
