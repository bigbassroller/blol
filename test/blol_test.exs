defmodule BlolTest do
  use ExUnit.Case
  doctest Blol

  test "greets the world" do
    assert Blol.hello() == :world
  end
end
