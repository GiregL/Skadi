defmodule Skadi.Repo do
  use Ecto.Repo,
    otp_app: :skadi,
    adapter: Ecto.Adapters.Postgres
end
