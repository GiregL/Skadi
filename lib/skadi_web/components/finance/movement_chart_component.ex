defmodule SkadiWeb.Components.Finance.MovementChartComponent do
  use SkadiWeb, :live_component

  @moduledoc """
  Renders a chart of dates and amounts.

  Attributes:
  - labels: a list of Date structs (ISO8601).
  - data: a list of float, reprensenting the amounts per dates.
  """

  @impl true
  def render(assigns) do
    ~H"""
    <div class="card bg-base-200 shadow p-4">
      <div class="h-40">
        <canvas
              id={"chart-#{@id}"}
              phx-hook="FinanceMovementChart"
              data-labels={Jason.encode!(@labels)}
              data-data={Jason.encode!(@data)}
              class="w-full h-full"
        ></canvas>
      </div>
    </div>

    """
  end

end
