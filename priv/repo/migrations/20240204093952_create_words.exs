defmodule DemoGame.Repo.Migrations.CreateWords do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :guess_word, :text

      timestamps(type: :utc_datetime)
    end
  end
end
