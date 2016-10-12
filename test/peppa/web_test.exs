defmodule WebTest do
  use ExUnit.Case
  use Plug.Test

  alias Peppa.Web

  @opts Web.init([])

  @timestamp     "1475965933"
  @nonce         "1320562132"
  @msg_signature "7a0d83e1708ea345e2762553d54b4d9b6787ea4f"
  @weixin_cb_payload """
<xml>
<Encrypt><![CDATA[dDVoe9m1ehQ5NcFSahjzg/N5JEmbByIsDwhxDlF7aMhiNOdC+XUyKMngRJfCxckAcyqpJG4ErdWhlbpI4XSev0l4aJDdTvT6onR8/wTzXz6LpnRzKMa6qLu1lLo9u6E/XSp2aN7lKG3ealgD6lNx0w5wuJ2I2uorj8+B3ONOPWzQTHvrPdkSQ7QitKZicU6KyS3WL1PwHl4LlSGyPI30Cs4yHcD/kKSFGHbBhRHW3AAPD2jEodR6gsSrLgoe+7Lq4VLxDmp9QFCJnttQ1ZfPd/ZuZsbbWffVarxo0zjX5XjyghCIHMXB+8QFpUbTRAUHAWPwgjxh9Tw020a1qsXjyy7dUEjsPJRGaWU9aud6DzY22tDQjbFO+/o/PuhThf3PNKoD5U4gt2m7Bd8dqnpPOCuCGSHTIo1p4X82eqWuTmpTdAw5K61TCf2xbo0Z7ufljtsbq0OK1q7Bf8MIQe48HQ==]]></Encrypt>
<MsgSignature><![CDATA[7a0d83e1708ea345e2762553d54b4d9b6787ea4f]]></MsgSignature>
<TimeStamp>1475965933</TimeStamp>
<Nonce><![CDATA[1320562132]]></Nonce>
</xml>
  """
  @component_verify_ticket "ticket@@@QZJ7ZseLV0EjnW6TQahrdDf7sIKBY1IAWjl3Rzps6XMXc-XQRSygXs_AzR1D7o2seO08zL7LYka8IsGiYbhgDA"
  @expected_key "we_whisper_test:component_verify_ticket:wx2c2769f8efd9abc2:ticket"

  setup do
    Logger.disable(self())

    on_exit fn ->
      Redix.command(:redix, ~w(DEL #{@expected_key}))
    end
  end

  test "ok" do
    conn = conn(:get, "/")
           |> Web.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "ok"
  end

  describe "weixin component_verify_ticket callback" do
    setup do
      url = "weixin_callback?timestamp=#{@timestamp}&nonce=#{@nonce}&encrypt_type=aes&msg_signature=#{@msg_signature}"

      conn =
        conn(:post, url, @weixin_cb_payload)
        |> put_req_header("content-type", "text/plain")
        |> Web.call(@opts)

      {:ok, conn: conn}
    end

    test "returns success", %{conn: conn} do
      assert conn.status == 201
      assert conn.resp_body == "success"
    end

    test "saves component_verify_ticket", %{conn: _} do
      {:ok, value} = Peppa.RedisStore.get(@expected_key)
      assert @component_verify_ticket == value
    end
  end

  test "/:app_id/callback" do
    url = "/wx12345/callback?timestamp=#{@timestamp}&nonce=#{@nonce}&encrypt_type=aes&msg_signature=#{@msg_signature}"

    conn = conn(:post, url, @weixin_cb_payload)
           |> put_req_header("content-type", "text/plain")
           |> Web.call(@opts)

    assert conn.status == 201
    assert conn.resp_body == "success"
  end
end
