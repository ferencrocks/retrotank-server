defmodule Retrotank.Game.Core.Object do
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
