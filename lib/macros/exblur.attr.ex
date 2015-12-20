defmodule Macros.Exblur.Attr do
  defmacro attr(key, value) do
    quote do
      @unquote(key)(unquote(value))
      def unquote(key)(), do: @unquote(key)()
    end
  end
end
