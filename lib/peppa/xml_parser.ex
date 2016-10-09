defmodule Peppa.XmlParser do
  alias Peppa.Error

  require Record
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  def get(xml, key) when is_binary(xml) do
    try do
      { xml, _rest } = :xmerl_scan.string(:erlang.bitstring_to_list(xml))
      [ element ] = :xmerl_xpath.string(to_char_list("/xml/#{key}"), xml)
      [ text ] = xmlElement(element, :content)
      xmlText(text, :value) |> to_string
    rescue
      MatchError -> raise Error, reason: "failed get content from key in xml"
    catch
      :exit, _ -> raise Error, reason: "failed to parse xml"
    end
  end
end
