defmodule SkadiWeb.FinanceComponents do
  use Phoenix.Component
  use Gettext, backend: SkadiWeb.Gettext

  # alias Phoenix.LiveView.JS

  @moduledoc """
  Helper components to manage Finance related stuff.
  """

  @doc """
  Shows a given Decimal amount as a currency.
  """
  attr :value, Decimal
  attr :currency, :string, default: "EUR"
  attr :locale, :string, default: "fr"

  def currency_amount(assigns) do
    ~H"""
    {Skadi.Cldr.Number.to_string!(@value, format: :currency, currency: @currency, locale: @locale)}
    """
  end

  @doc """
  Shows a badge for a given movement direction.

  Supported values:

  - :income
  - :expense
  """

  attr :value, :atom

  def direction_badge(assigns) do
    case assigns.value do
      :income -> ~H"""
      <span class="badge badge-soft badge-success">{gettext("income")}</span>
      """
      :expense -> ~H"""
      <span class="badge badge-soft badge-error">{gettext("expense")}</span>
      """
      _ -> ~H"""
      <span class="badge badge-soft badge-neutral">{Atom.to_string(@value)}</span>
      """
    end
  end
end
