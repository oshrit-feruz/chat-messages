defmodule DemoGame.Repo do
  use Ecto.Repo,
    otp_app: :demo_game,
    adapter: Ecto.Adapters.Postgres
end
