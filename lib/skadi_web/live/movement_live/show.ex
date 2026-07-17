defmodule SkadiWeb.MovementLive.Show do
  use SkadiWeb, :live_view

  alias Skadi.Finances

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Movement {@movement.id}
        <:subtitle>This is a movement record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/finances/movements"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/finances/movements/#{@movement}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit movement
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Direction">{@movement.direction}</:item>
        <:item title="Source">{@movement.source}</:item>
        <:item title="Destination">{@movement.destination}</:item>
        <:item title="Notes">{@movement.notes}</:item>
        <:item title="Date">{@movement.date}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Finances.subscribe_movements(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Movement")
     |> assign(:movement, Finances.get_movement!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Skadi.Finances.Movement{id: id} = movement},
        %{assigns: %{movement: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :movement, movement)}
  end

  def handle_info(
        {:deleted, %Skadi.Finances.Movement{id: id}},
        %{assigns: %{movement: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current movement was deleted.")
     |> push_navigate(to: ~p"/finances/movements")}
  end

  def handle_info({type, %Skadi.Finances.Movement{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
