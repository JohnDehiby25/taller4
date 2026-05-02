defmodule InventarioAppTest do
  use ExUnit.Case
  doctest InventarioApp

  test "greets the world" do
    assert InventarioApp.hello() == :world
  end
end
