defmodule DemoGame.ChatMessages do
  @moduledoc """
  The ChatMessages context.
  """

  import Ecto.Query, warn: false
  alias DemoGame.Repo

  alias DemoGame.ChatMessages.UserMessage

  @doc """
  Returns the list of user_messages.

  ## Examples

      iex> list_user_messages()
      [%UserMessage{}, ...]

  """
  def list_user_messages(user_id) do
    Repo.all(UserMessage)
  end

  @doc """
  Gets a single user_message.

  Raises `Ecto.NoResultsError` if the User message does not exist.

  ## Examples

      iex> get_user_message!(123)
      %UserMessage{}

      iex> get_user_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_message!(id), do: Repo.get!(UserMessage, id)

  @doc """
  Creates a user_message.

  ## Examples

      iex> create_user_message(%{field: value})
      {:ok, %UserMessage{}}

      iex> create_user_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_message(attrs \\ %{}) do
    %UserMessage{}
    |> UserMessage.changeset(Map.put(attrs, "user_name", attrs["user_name"]))
    |> Repo.insert()
  end

  @doc """
  Updates a user_message.

  ## Examples

      iex> update_user_message(user_message, %{field: new_value})
      {:ok, %UserMessage{}}

      iex> update_user_message(user_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_message(%UserMessage{} = user_message, attrs) do
    user_message
    |> UserMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_message.

  ## Examples

      iex> delete_user_message(user_message)
      {:ok, %UserMessage{}}

      iex> delete_user_message(user_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_message(%UserMessage{} = user_message) do
    Repo.delete(user_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_message changes.

  ## Examples

      iex> change_user_message(user_message)
      %Ecto.Changeset{data: %UserMessage{}}

  """
  def change_user_message(%UserMessage{} = user_message, attrs \\ %{}) do
    UserMessage.changeset(user_message, attrs)
  end
end
