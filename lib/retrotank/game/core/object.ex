defmodule Retrotank.Game.Core.Object do
  @type dir() :: :up | :down | :left | :right

  alias Retrotank.Game.Core.Movement
  import Movement

  def id(object) do
    object.id
  end

  def assign_id(object, id) do
    %{ object | id: id }
  end

  def direction(movement = %{ movement: %Movement{} }) do
    Movement.direction(movement)
  end

  def direction(object = %{ movement: %Movement{} }, direction) when Movement.is_direction(direction) do
    %{ object | movement: Movement.direction(object.movement, direction) }
  end

  def is_moving?(object = %{ movement: %Movement{} }) do
    Movement.is_moving?(object.movement)
  end

  def is_moving(object = %{ movement: %Movement{} }, is_moving) when is_boolean(is_moving) do
    %{ object | movement: Movement.is_moving(object.movement, is_moving) }
  end


  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      alias Retrotank.Game.Core.Coord
      alias Retrotank.Game.Core.Movement
      alias Retrotank.Game.Core.Health

      # ***** moving objects *****
      if Keyword.get(opts, :movable, false) do
        @doc """
        Can the object move?
        """
        def movable?, do: true

        @doc """
        Gets the direction of a game object.
        """
        def direction(%{ movement: %Movement{ direction: direction } }) do
          direction
        end

        @doc """
        Sets the direction of a game object.

        ## Parameters:
        - object: the game object
        - new_direction: :up, :down, :left or :right

        """
        def direction(object, new_direction) do
          %{ movement: movement } = object
          new_movement = Movement.direction(movement, new_direction)

          %{ object | movement: new_movement }
        end
      else
        @doc """
        Can the object move?
        """
        def movable?, do: false
      end

      # ***** object size *****
      @width 32
      @height 32
      def width(%{size: %{ width: width }}), do: width
      def height(%{size: %{ height: height }}), do: height


      # ***** object health *****
      @lives 1
      def lives(%{health: %{ lives: lives }}) do
        lives
      end


    end
  end

end
