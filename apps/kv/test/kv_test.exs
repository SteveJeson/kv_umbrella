defmodule KVTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link([])
    %{bucket: bucket}
  end

  test "greets the world" do
    assert KV.hello() == :world
  end

  test "stores value by key" , %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3
  end

  test "delete value by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "peer") == nil

    KV.Bucket.put(bucket, "peer", 1)
    assert KV.Bucket.get(bucket, "peer") == 1

    KV.Bucket.delete(bucket, "peer")
    assert KV.Bucket.get(bucket, "peer") == nil
  end
end
