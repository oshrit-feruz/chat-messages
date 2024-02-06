defmodule DemoGameWeb.WordLive.New do
  use DemoGameWeb, :live_view
  alias DemoGame.Words

  def mount(_params, _session, socket) do
    changeset = Words.Word.changeset(%Words.Word{})
    user_id = socket.assigns.current_user.id

    socket =
      socket
      |> assign(:form, to_form(changeset))
      |> assign(:user_id, user_id)

    {:ok, socket}
  end

  def handle_event("save", %{"word" => word_params}, socket) do
    params = word_params
      |> Map.put("user_id",socket.assigns.current_user.id)

    case Words.create_word(params) do
      {:ok, _word} ->
        socket =
          socket
            |> put_flash(:info, "Word created")
            |> redirect(to: ~p"/words")
        {:noreply, socket}
      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
