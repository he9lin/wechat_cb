defmodule Peppa.RepoTest do
  use ExUnit.Case
  alias Peppa.Repo

  @component_verify_ticket "ticket@@@XDvE-9Ai2O7ZivDdsWQm2bJn-JjUMXYYF1CZHERUqEylechkn4jbAY0BspvQW9nVSBcTjTZtUQvz4tSy3yePZw"
  @expected_key "we_whisper_test:component_verify_ticket:wx9bd52800ff14f997:ticket"

  setup do
    on_exit fn ->
      Redix.command(:redix, ~w(DEL #{@expected_key}))
    end
  end

  test "stores component_verify_ticket" do
    info = %Peppa.ComponentVerifyTicket{
      AppId: "wx9bd52800ff14f997",
      CreateTime: "1475950934",
      InfoType: "component_verify_ticket",
      ComponentVerifyTicket: @component_verify_ticket
    }

    {:ok, key} = Repo.insert info, Peppa.RedisStore
    assert @expected_key == key
    {:ok, value} = Peppa.RedisStore.get(key)
    assert @component_verify_ticket == value
  end
end
