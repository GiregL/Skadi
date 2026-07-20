defmodule SkadiWeb.DashboardLive.Dashboard do
  use SkadiWeb, :live_view

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
    </Layouts.app>
    """
  end
end
