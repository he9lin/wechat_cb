defprotocol Peppa.RepoInsertable do
  def key(model)
  def value(model)
end

defimpl Peppa.RepoInsertable, for: Peppa.ComponentVerifyTicket do
  def key(%Peppa.ComponentVerifyTicket{AppId: app_id, InfoType: info_type}) do
    [info_type, app_id, "ticket"] |> Enum.join(":")
  end

  def value(%Peppa.ComponentVerifyTicket{ComponentVerifyTicket: ticket}), do: ticket
end
