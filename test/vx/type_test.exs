defmodule Vx.TypeTest do
  use ExUnit.Case

  import Vx.Type

  test "details/1" do
    assert details(Vx.Any.t()) == %{}
    assert details(Vx.List.t()) == %{}
    assert details(Vx.List.t(Vx.String.t())) == %{of: Vx.String.t()}
    assert details(Vx.String.min_length(3)) == %{}
  end

  test "details/2" do
    assert details(Vx.Any.t(), :foo) == %{}
    assert details(Vx.String.max_length(4), :min_length) == %{}

    assert details(Vx.String.min_length(3), :min_length) == %{
             length: 3
           }
  end
end
