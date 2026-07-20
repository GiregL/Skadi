defmodule SkadiWeb.ServiceLive.Index do
  use SkadiWeb, :live_view

  alias Skadi.Inventory

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Services
        <:actions>
          <.button variant="primary" navigate={~p"/inventory/services/new"}>
            <.icon name="hero-plus" /> New Service
          </.button>
        </:actions>
      </.header>

      <.table
        id="services"
        rows={@streams.services}
        row_click={fn {_id, service} -> JS.navigate(~p"/inventory/services/#{service}") end}
      >
        <:col :let={{_id, service}} label="Name">{service.name}</:col>
        <:col :let={{_id, service}} label="Amount">{service.amount}</:col>
        <:col :let={{_id, service}} label="Starting date">{service.starting_date}</:col>
        <:col :let={{_id, service}} label="Frequency">{service.frequency}</:col>
        <:action :let={{_id, service}}>
          <div class="sr-only">
            <.link navigate={~p"/inventory/services/#{service}"}>Show</.link>
          </div>
          <.link navigate={~p"/inventory/services/#{service}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, service}}>
          <.link
            phx-click={JS.push("delete", value: %{id: service.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Inventory.subscribe_services(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Services")
     |> stream(:services, list_services(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    service = Inventory.get_service!(socket.assigns.current_scope, id)
    {:ok, _} = Inventory.delete_service(socket.assigns.current_scope, service)

    {:noreply, stream_delete(socket, :services, service)}
  end

  @impl true
  def handle_info({type, %Skadi.Inventory.Service{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :services, list_services(socket.assigns.current_scope), reset: true)}
  end

  defp list_services(current_scope) do
    Inventory.list_services(current_scope)
  end
end
