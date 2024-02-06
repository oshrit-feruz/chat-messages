defmodule DemoGameWeb.HomeLive do
  use DemoGameWeb, :live_view

    alias DemoGame.ChatMessages

  @impl true
  def render(%{loading: true} = assigns) do
    ~H"""
    Messages are loading ...
    """
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-2">
            <button phx-click="delete_all_messages" class="max-w-[190px] bg-red-500 text-white hover:bg-red-600 rounded p-2 transition duration-0 hover:duration-150">Delete All Messages</button>
        <div class="bg-slate-200 rounded-lg p-7 w-full min-h-[600px]">
          <div class="flex gap-1 flex-col min-h-[600px] justify-between">
              <div class="flex flex-col">
              <b>  Listing User messages</b>
                  <%= for message <- @messages do %>
                  <h1><%= message %></h1>
                  <% end %>
                  </div>
                  <.form for={@form} phx-submit="send" class="flex gap-2 justify-center align-center items-center">
                  <.input type="text"  field={@form[:message]} />
                  <button class="bg-slate-500 h-[40px] mt-2 text-sm text-white hover:bg-slate-600 rounded p-2 transition duration-0 hover:duration-150">Send</button>
                </.form>
          </div>
        </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(DemoGame.PubSub, "messages")
      user_id = socket.assigns.current_user.id
      changeset = ChatMessages.UserMessage.changeset(%ChatMessages.UserMessage{})
      messages = ChatMessages.list_user_messages(user_id)


      socket =
        socket
        |> assign(:form, to_form(changeset))
        |> assign(:messages, messages)
        |> stream(:messages, ChatMessages.list_user_messages(user_id))

    {:ok, socket}
    else
      {:ok, assign(socket, loading: true)}
    end
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("delete_all_messages", _params, socket) do
    user_id = socket.assigns.current_user.id
    messages = ChatMessages.list_user_messages(user_id)

    # Delete all messages
    Enum.each(messages, &ChatMessages.delete_user_message(&1))

    {:noreply, assign(socket, messages: [])}
  end

  def handle_event("send", %{"user_message" => %{"message" => message}}, socket) do
    %{current_user: user} = socket.assigns
    user_id = socket.assigns.current_user.id |> Integer.to_string()
    params = %{"message" => message, "user_name" => user_id}


    case ChatMessages.create_user_message(params) do
      {:ok, new_message} ->
        socket =
          socket
          |> put_flash(:info, "Message Sent")
          |> push_navigate(to: ~p"/home")
          |> assign(:messages, ChatMessages.list_user_messages(socket.assigns.current_user.id))

          Phoenix.PubSub.broadcast(DemoGame.PubSub, "messages", {:new, Map.put(new_message, :user, user)})

        {:noreply, socket}
      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true

  def handle_info({:new, new_message}, socket) do
    updated_socket =
      socket
      |> put_flash(:info, "new message!")
      |> stream_insert(:messages, new_message, at: 0)

    {:noreply, updated_socket}
    |> push_event("messages", %{messages: updated_socket.assigns.messages})
  end
end
