defmodule DemoGame.Words.Word do
  use Ecto.Schema
  import Ecto.Changeset

  schema "words" do
    field :guess_word, :string
    belongs_to :user, DemoGame.Users.User

    timestamps(type: :utc_datetime)
  end


  defimpl Phoenix.HTML.Safe, for: DemoGame.Words.Word do
    def to_iodata(word) do
      Phoenix.HTML.Safe.to_iodata(word.guess_word)
    end
  end

  @doc false
  def changeset(word, attrs \\ %{}) do
    word
    |> cast(attrs, [:guess_word, :user_id ])
    |> validate_required([:guess_word, :user_id ])
  end
end
