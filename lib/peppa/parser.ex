defmodule Peppa.Parser do
  import Peppa.XmlParser, only: [get: 2]

  def parse(module, xml_content) do
    try do
      {:ok,
        module
        |> Map.from_struct
        |> Dict.keys
        |> Enum.reduce(struct(module, %{}), fn(key, m) -> %{m | key => get(xml_content,Atom.to_string(key))} end)
      }
    rescue
      e in Peppa.Error -> {:error, e}
    end
  end
end
