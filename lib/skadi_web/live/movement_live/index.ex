defmodule SkadiWeb.MovementLive.Index do
  use SkadiWeb, :live_view

  import SkadiWeb.FinanceComponents

  alias Skadi.Finances

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Liste des mouvements
        <:actions>
          <.button variant="primary" navigate={~p"/finances/movements/new"}>
            <.icon name="hero-plus" /> Nouveau mouvement
          </.button>
        </:actions>
      </.header>

      <.table
        id="movements"
        rows={@streams.movements}
        row_click={fn {_id, movement} -> JS.navigate(~p"/finances/movements/#{movement}") end}
      >
        <:col :let={{_id, movement}} label="Direction">
          <.direction_badge value={movement.direction}/>
        </:col>
        <:col :let={{_id, movement}} label="Source">{movement.source}</:col>
        <:col :let={{_id, movement}} label="Destination">{movement.destination}</:col>
        <:col :let={{_id, movement}} label="Montant"><.currency_amount value={movement.amount}/></:col>
        <:col :let={{_id, movement}} label="Date">
          <.show_date value={movement.date}/>
        </:col>
        <:action :let={{_id, movement}}>
          <div class="sr-only">
            <.link navigate={~p"/finances/movements/#{movement}"}>Afficher</.link>
          </div>
          <.link navigate={~p"/finances/movements/#{movement}/edit"}>Modifier</.link>
        </:action>
        <:action :let={{id, movement}}>
          <.link
            phx-click={JS.push("delete", value: %{id: movement.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Supprimer
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Finances.subscribe_movements(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Movements")
     |> stream(:movements, list_movements(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    movement = Finances.get_movement!(socket.assigns.current_scope, id)
    {:ok, _} = Finances.delete_movement(socket.assigns.current_scope, movement)

    {:noreply, stream_delete(socket, :movements, movement)}
  end

  @impl true
  def handle_info({type, %Skadi.Finances.Movement{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :movements, list_movements(socket.assigns.current_scope), reset: true)}
  end

  defp list_movements(current_scope) do
    Finances.list_movements(current_scope)
  end
end
