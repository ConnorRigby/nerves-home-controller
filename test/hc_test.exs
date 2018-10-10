defmodule HcTest do
  use ExUnit.Case
  doctest Hc

  test "greets the world" do
    assert Hc.hello() == :world
  end
end
