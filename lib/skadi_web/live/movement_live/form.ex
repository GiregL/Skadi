defmodule SkadiWeb.MovementLive.Form do
  use SkadiWeb, :live_view

  alias Skadi.Finances
  alias Skadi.Finances.Movement

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage movement records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="movement-form" phx-change="validate" phx-submit="save">
        <.input
          field={@form[:direction]}
          type="select"
          label="Direction"
          prompt="- Choose a value -"
          options={Ecto.Enum.values(Skadi.Finances.Movement, :direction)}
        />
        <.input field={@form[:source]} type="text" label="Source" />
        <.input field={@form[:destination]} type="text" label="Destination" />
        <.input field={@form[:amount]} type="number" label="Montant" min="0" step="0.01"/>
        <.input field={@form[:notes]} type="textarea" label="Notes" />
        <.input field={@form[:date]} type="date" label="Date" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Movement</.button>
          <.button navigate={return_path(@current_scope, @return_to, @movement)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    movement = Finances.get_movement!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Movement")
    |> assign(:movement, movement)
    |> assign(:form, to_form(Finances.change_movement(socket.assigns.current_scope, movement)))
  end

  defp apply_action(socket, :new, _params) do
    movement = %Movement{
      user_id: socket.assigns.current_scope.user.id,
      date: Date.utc_today(),
      amount: 0,
      direction: :expense
    }

    socket
    |> assign(:page_title, "New Movement")
    |> assign(:movement, movement)
    |> assign(:form, to_form(Finances.change_movement(socket.assigns.current_scope, movement)))
  end

  @impl true
  def handle_event("validate", %{"movement" => movement_params}, socket) do
    changeset = Finances.change_movement(socket.assigns.current_scope, socket.assigns.movement, movement_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"movement" => movement_params}, socket) do
    save_movement(socket, socket.assigns.live_action, movement_params)
  end

  defp save_movement(socket, :edit, movement_params) do
    case Finances.update_movement(socket.assigns.current_scope, socket.assigns.movement, movement_params) do
      {:ok, movement} ->
        {:noreply,
         socket
         |> put_flash(:info, "Movement updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, movement)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_movement(socket, :new, movement_params) do
    case Finances.create_movement(socket.assigns.current_scope, movement_params) do
      {:ok, movement} ->
        {:noreply,
         socket
         |> put_flash(:info, "Movement created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, movement)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _movement), do: ~p"/finances/movements"
  defp return_path(_scope, "show", movement), do: ~p"/finances/movements/#{movement}"
end
