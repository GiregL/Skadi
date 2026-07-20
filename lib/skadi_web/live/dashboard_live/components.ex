defmodule SkadiWeb.DashboardLive.Components do
  use SkadiWeb, :html
  use Gettext, backend: SkadiWeb.Gettext

  # alias Phoenix.LiveView.JS

  @moduledoc """
  Module hosting many components dedicated to the Dashboard
  """

  @doc """
  Navigation shortcuts for quick actions.
  """
  def quick_links(assigns) do
    ~H"""
    <div class="card px-6 py-4 w-full flex flex-row gap-2 items-center bg-primary-100 rounded shadow-lg">
      <.link href={~p"/finances/movements/new"} class="btn btn-primary"><.icon name="hero-arrows-right-left" class="w-5 h-5"/> Ajouter un mouvement</.link>
    </div>
    """
  end
end
