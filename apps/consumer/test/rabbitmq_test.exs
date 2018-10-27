defmodule RabbitmqTest do
  use ExUnit.Case

  test "greets the map" do
    map = %{}
    map = Map.put(map, :mile, 20)
    assert map[:mile] == 20
  end
end
