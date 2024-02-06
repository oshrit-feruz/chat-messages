defmodule DemoGame.ChatMessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DemoGame.ChatMessages` context.
  """

  @doc """
  Generate a user_message.
  """
  def user_message_fixture(attrs \\ %{}) do
    {:ok, user_message} =
      attrs
      |> Enum.into(%{
        message: "some message",
        user_name: "some user_name"
      })
      |> DemoGame.ChatMessages.create_user_message()

    user_message
  end
end
