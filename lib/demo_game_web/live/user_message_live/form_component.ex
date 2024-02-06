defmodule DemoGameWeb.UserMessageLive.FormComponent do
  use DemoGameWeb, :live_component

  alias DemoGame.ChatMessages

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage user_message records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="user_message-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:message]} type="text" label="Message" />
        <.input field={@form[:user_name]} type="text" label="User name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save User message</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user_message: user_message} = assigns, socket) do
    changeset = ChatMessages.change_user_message(user_message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"user_message" => user_message_params}, socket) do
    changeset =
      socket.assigns.user_message
      |> ChatMessages.change_user_message(user_message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"user_message" => user_message_params}, socket) do
    save_user_message(socket, socket.assigns.action, user_message_params)
  end

  defp save_user_message(socket, :edit, user_message_params) do
    case ChatMessages.update_user_message(socket.assigns.user_message, user_message_params) do
      {:ok, user_message} ->
        notify_parent({:saved, user_message})

        {:noreply,
         socket
         |> put_flash(:info, "User message updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_user_message(socket, :new, user_message_params) do
    case ChatMessages.create_user_message(user_message_params) do
      {:ok, user_message} ->
        notify_parent({:saved, user_message})

        {:noreply,
         socket
         |> put_flash(:info, "User message created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
