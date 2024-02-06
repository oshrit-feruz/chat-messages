defmodule DemoGame.ChatMessagesTest do
  use DemoGame.DataCase

  alias DemoGame.ChatMessages

  describe "user_messages" do
    alias DemoGame.ChatMessages.UserMessage

    import DemoGame.ChatMessagesFixtures

    @invalid_attrs %{message: nil, user_name: nil}

    test "list_user_messages/0 returns all user_messages" do
      user_message = user_message_fixture()
      assert ChatMessages.list_user_messages() == [user_message]
    end

    test "get_user_message!/1 returns the user_message with given id" do
      user_message = user_message_fixture()
      assert ChatMessages.get_user_message!(user_message.id) == user_message
    end

    test "create_user_message/1 with valid data creates a user_message" do
      valid_attrs = %{message: "some message", user_name: "some user_name"}

      assert {:ok, %UserMessage{} = user_message} = ChatMessages.create_user_message(valid_attrs)
      assert user_message.message == "some message"
      assert user_message.user_name == "some user_name"
    end

    test "create_user_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ChatMessages.create_user_message(@invalid_attrs)
    end

    test "update_user_message/2 with valid data updates the user_message" do
      user_message = user_message_fixture()
      update_attrs = %{message: "some updated message", user_name: "some updated user_name"}

      assert {:ok, %UserMessage{} = user_message} = ChatMessages.update_user_message(user_message, update_attrs)
      assert user_message.message == "some updated message"
      assert user_message.user_name == "some updated user_name"
    end

    test "update_user_message/2 with invalid data returns error changeset" do
      user_message = user_message_fixture()
      assert {:error, %Ecto.Changeset{}} = ChatMessages.update_user_message(user_message, @invalid_attrs)
      assert user_message == ChatMessages.get_user_message!(user_message.id)
    end

    test "delete_user_message/1 deletes the user_message" do
      user_message = user_message_fixture()
      assert {:ok, %UserMessage{}} = ChatMessages.delete_user_message(user_message)
      assert_raise Ecto.NoResultsError, fn -> ChatMessages.get_user_message!(user_message.id) end
    end

    test "change_user_message/1 returns a user_message changeset" do
      user_message = user_message_fixture()
      assert %Ecto.Changeset{} = ChatMessages.change_user_message(user_message)
    end
  end
end
