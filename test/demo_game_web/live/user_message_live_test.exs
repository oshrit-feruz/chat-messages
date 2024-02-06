defmodule DemoGameWeb.UserMessageLiveTest do
  use DemoGameWeb.ConnCase

  import Phoenix.LiveViewTest
  import DemoGame.ChatMessagesFixtures

  @create_attrs %{message: "some message", user_name: "some user_name"}
  @update_attrs %{message: "some updated message", user_name: "some updated user_name"}
  @invalid_attrs %{message: nil, user_name: nil}

  defp create_user_message(_) do
    user_message = user_message_fixture()
    %{user_message: user_message}
  end

  describe "Index" do
    setup [:create_user_message]

    test "lists all user_messages", %{conn: conn, user_message: user_message} do
      {:ok, _index_live, html} = live(conn, ~p"/user_messages")

      assert html =~ "Listing User messages"
      assert html =~ user_message.message
    end

    test "saves new user_message", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/user_messages")

      assert index_live |> element("a", "New User message") |> render_click() =~
               "New User message"

      assert_patch(index_live, ~p"/user_messages/new")

      assert index_live
             |> form("#user_message-form", user_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_message-form", user_message: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_messages")

      html = render(index_live)
      assert html =~ "User message created successfully"
      assert html =~ "some message"
    end

    test "updates user_message in listing", %{conn: conn, user_message: user_message} do
      {:ok, index_live, _html} = live(conn, ~p"/user_messages")

      assert index_live |> element("#user_messages-#{user_message.id} a", "Edit") |> render_click() =~
               "Edit User message"

      assert_patch(index_live, ~p"/user_messages/#{user_message}/edit")

      assert index_live
             |> form("#user_message-form", user_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_message-form", user_message: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_messages")

      html = render(index_live)
      assert html =~ "User message updated successfully"
      assert html =~ "some updated message"
    end

    test "deletes user_message in listing", %{conn: conn, user_message: user_message} do
      {:ok, index_live, _html} = live(conn, ~p"/user_messages")

      assert index_live |> element("#user_messages-#{user_message.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_messages-#{user_message.id}")
    end
  end

  describe "Show" do
    setup [:create_user_message]

    test "displays user_message", %{conn: conn, user_message: user_message} do
      {:ok, _show_live, html} = live(conn, ~p"/user_messages/#{user_message}")

      assert html =~ "Show User message"
      assert html =~ user_message.message
    end

    test "updates user_message within modal", %{conn: conn, user_message: user_message} do
      {:ok, show_live, _html} = live(conn, ~p"/user_messages/#{user_message}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User message"

      assert_patch(show_live, ~p"/user_messages/#{user_message}/show/edit")

      assert show_live
             |> form("#user_message-form", user_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#user_message-form", user_message: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/user_messages/#{user_message}")

      html = render(show_live)
      assert html =~ "User message updated successfully"
      assert html =~ "some updated message"
    end
  end
end
