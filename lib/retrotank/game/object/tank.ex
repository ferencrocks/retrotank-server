defmodule Retrotank.Game.Object.Tank do
  alias Retrotank.Game.Core
  use Core.Object, alive: true, movable: true

  alias Core.Coord
  alias Core.Size
  alias Core.Movement
  alias Core.Health


  defstruct id: Retrotank.Utils.Random.uuid(),
    props: %{ color: nil, size: 0 },
    position: %Coord{},
    size: %Size{ width: @width, height: @height },
    movement: %Movement{},
    health: %Health{}

  defmacro colors do
    quote do
      [:red, :green, :yellow, :silver]
    end
  end

  defmacro sizes do
    quote do
      [0, 1, 2, 3, 4, 5, 6, 7]
    end
  end

  def color(tank) do
    tank.props.color
  end

  def color(tank, color) when color in [] do
    %{ tank | props: %{ color: color } }
  end
end
