defmodule DemoGameWeb.UserMessageLive.Index do
  use DemoGameWeb, :live_view
  alias DemoGame.ChatMessages

  def mount(_params, _session, socket) do
    changeset = ChatMessages.UserMessage.changeset(%ChatMessages.UserMessage{})
    user_id = socket.assigns.current_user.id
    IO.inspect("User #{socket.assigns.current_user.id} joined the channel")

    messages = ChatMessages.list_user_messages(user_id)

    socket =
      socket
      |> assign(:messages, messages)
      |> assign(:form, to_form(changeset))
      |> assign(:current_user_id, user_id)

    {:ok, socket}
  end
  def handle_info(%{event: "new_message", payload: %{message: new_message}} = msg, socket) do
    updated_messages = [new_message | socket.assigns.messages]
    IO.inspect(updated_messages, label: "Updated Messages")

    DemoGameWeb.Endpoint.broadcast("room:lobby", "new_message", %{message: new_message})

    {:noreply, assign(socket, messages: updated_messages)}
  end


  def handle_event("saving", %{"user_message" => %{"message" => message}}, socket) do
    params = %{"message" => message, "user_name" =>socket.assigns.current_user.id}

    case ChatMessages.create_user_message(params) do
      {:ok, new_message} ->
        socket =
          socket
          |> put_flash(:info, "Message Sent")
          |> assign(:messages, ChatMessages.list_user_messages(socket.assigns.current_user.id))
        {:noreply, socket}
      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


end
