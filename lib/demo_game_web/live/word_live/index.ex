defmodule DemoGameWeb.WordLive.Index do
  use DemoGameWeb, :live_view
  alias DemoGame.Words


  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    socket = socket
    assign(:words, Words.list_words(user_id))

    {:ok, socket}
  end

end
