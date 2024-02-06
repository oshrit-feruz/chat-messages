defmodule DemoGame.Repo.Migrations.CreateUserMessages do
  use Ecto.Migration

  def change do
    create table(:user_messages) do
      add :message, :string
      add :user_name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
