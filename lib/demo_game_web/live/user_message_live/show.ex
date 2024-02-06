defmodule DemoGameWeb.UserMessageLive.New do
  use DemoGameWeb, :live_view

  alias DemoGame.ChatMessages

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user_message, ChatMessages.get_user_message!(id))}
  end

  defp page_title(:show), do: "Show User message"
  defp page_title(:edit), do: "Edit User message"
end
