defmodule SkadiWeb.DashboardLive.Dashboard do
  use SkadiWeb, :live_view

  import SkadiWeb.DashboardLive.Components

  @moduledoc """
  Personal dashboard.

  Compiles multiple data sources for a single user.
  """

  @impl true
  def mount(_params, _session, socket) do
    _current_user = socket.assigns.current_scope.user

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Tableau de bord
      </.header>

      <.quick_links/>
    </Layouts.app>
    """
  end
end
