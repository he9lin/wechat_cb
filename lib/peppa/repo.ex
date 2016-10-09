defmodule Peppa.Repo do
  alias Peppa.RepoInsertable

  @db_prefix Application.get_env(:peppa, :db_prefix)

  def insert(model, store) do
    with key <- RepoInsertable.key(model),
       value <- RepoInsertable.value(model),
    full_key <- build_full_key(key),
         do: insert(full_key, value, store)
  end

  def insert(key, value, store) do
    case store.set(key, value) do
      :ok -> {:ok, key}
      other -> other
    end
  end

  defp build_full_key(key) do
    [@db_prefix, key] |> Enum.join(":")
  end
end
