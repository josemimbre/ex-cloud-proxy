defmodule KVServer.CommandTest do
  use ExUnit.Case, async: true
  doctest KVServer.Command

  setup context do
    _ = start_supervised!({KV.Registry, name: context.test})
    %{registry: context.test}
  end

  test "create buckets", %{registry: registry} do
    KVServer.Command.run({:create, "shopping"}, registry)

    KVServer.Command.run({:put, "shopping", "milk", 1}, registry)
    assert KVServer.Command.run({:get, "shopping", "milk"}, registry) == {:ok, "1\r\nOK\r\n"}
  end

  test "delete buckets keys", %{registry: registry} do
    KVServer.Command.run({:create, "shopping"}, registry)

    KVServer.Command.run({:put, "shopping", "milk", 1}, registry)
    assert KVServer.Command.run({:get, "shopping", "milk"}, registry) == {:ok, "1\r\nOK\r\n"}

    KVServer.Command.run({:delete, "shopping", "milk"}, registry)
    assert KVServer.Command.run({:get, "shopping", "milk"}, registry) == {:ok, "\r\nOK\r\n"}
  end
end
