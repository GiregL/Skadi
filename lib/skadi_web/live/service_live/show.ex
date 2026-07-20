defmodule SkadiWeb.ServiceLive.Show do
  use SkadiWeb, :live_view

  alias Skadi.Inventory

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Service {@service.id}
        <:subtitle>This is a service record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/inventory/services"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/inventory/services/#{@service}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit service
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@service.name}</:item>
        <:item title="Amount">{@service.amount}</:item>
        <:item title="Starting date">{@service.starting_date}</:item>
        <:item title="Frequency">{@service.frequency}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Inventory.subscribe_services(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Service")
     |> assign(:service, Inventory.get_service!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Skadi.Inventory.Service{id: id} = service},
        %{assigns: %{service: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :service, service)}
  end

  def handle_info(
        {:deleted, %Skadi.Inventory.Service{id: id}},
        %{assigns: %{service: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current service was deleted.")
     |> push_navigate(to: ~p"/inventory/services")}
  end

  def handle_info({type, %Skadi.Inventory.Service{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
