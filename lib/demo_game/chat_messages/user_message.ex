defmodule DemoGame.ChatMessages.UserMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_messages" do
    field :message, :string
    field :user_name, :string

    timestamps(type: :utc_datetime)
  end

  defimpl Phoenix.HTML.Safe, for: DemoGame.ChatMessages.UserMessage do
    def to_iodata(user_message) do
      Phoenix.HTML.Safe.to_iodata(user_message.message)
    end
  end
  @doc false
  def changeset(user_message, attrs \\ %{}) do
    user_message
    |> cast(attrs, [:message, :user_name])
    |> validate_required([:message, :user_name])
  end

end
