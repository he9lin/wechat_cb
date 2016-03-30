defmodule Peppa.SlackService do
  @slack_service_hook Application.get_env(:peppa, :slack_service_hook)

  def send(nil), do: :ignore
  def send(payload) do
    HTTPoison.post(@slack_service_hook, %{"text": payload} |> Poison.encode!)
  end
end
