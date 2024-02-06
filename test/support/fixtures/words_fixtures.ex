defmodule DemoGame.WordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DemoGame.Words` context.
  """

  @doc """
  Generate a word.
  """
  def word_fixture(attrs \\ %{}) do
    {:ok, word} =
      attrs
      |> Enum.into(%{
        guess_word: "some guess_word"
      })
      |> DemoGame.Words.create_word()

    word
  end
end
