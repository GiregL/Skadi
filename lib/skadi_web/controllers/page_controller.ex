defmodule SkadiWeb.PageController do
  use SkadiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
