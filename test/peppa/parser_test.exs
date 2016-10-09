defmodule Peppa.ParserTest do
  use ExUnit.Case
  alias Peppa.Parser

  @componet_verify_ticket_xml """
<xml>
<AppId><![CDATA[wx9bd52800ff14f997]]></AppId>
<CreateTime>1475950934</CreateTime>
<InfoType><![CDATA[component_verify_ticket]]></InfoType>
<ComponentVerifyTicket><![CDATA[ticket@@@XDvE-9Ai2O7ZivDdsWQm2bJn-JjUMXYYF1CZHERUqEylechkn4jbAY0BspvQW9nVSBcTjTZtUQvz4tSy3yePZw]]></ComponentVerifyTicket>
</xml>
  """

  test "parses component ticket xml" do
    assert {:ok, %Peppa.ComponentVerifyTicket{
      AppId: "wx9bd52800ff14f997",
      CreateTime: "1475950934",
      InfoType: "component_verify_ticket",
      ComponentVerifyTicket: "ticket@@@XDvE-9Ai2O7ZivDdsWQm2bJn-JjUMXYYF1CZHERUqEylechkn4jbAY0BspvQW9nVSBcTjTZtUQvz4tSy3yePZw"
    }} == Parser.parse(Peppa.ComponentVerifyTicket, @componet_verify_ticket_xml)
  end

  test "returns error" do
    assert {:error, %Peppa.Error{reason: "failed to parse xml"}} ==
      Parser.parse(Peppa.ComponentVerifyTicket, "invalidxml")
  end
end
