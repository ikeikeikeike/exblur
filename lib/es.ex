defmodule Es do
  require Logger

  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :ess, accumulate: true)
      @before_compile Es

      import Tirexs.Bulk
      import Tirexs.Mapping
      import Tirexs.Index.Settings
      import Tirexs.Manage.Aliases
      import Imitation.Converter, only: [to_i: 1]
      import Es

      require Tirexs.Manage
      require Tirexs.Query
      require Tirexs.Search
      require Logger
    end
  end

  defmacro es(name, options \\ []) do
    quote do
      @ess {unquote(name), unquote(options)}
    end
  end

  defmacro __before_compile__(env) do
    ess = Module.get_attribute(env.module, :ess)

    quote do
      def ess, do: unquote(ess)

      def get_index do
        index =
          ess[:model]
          |> to_string
          |> String.split(".")
          |> List.last
          |> String.downcase

        "es_#{index}"
      end
    end
  end

  def ppquery(queries) do
    Logger.debug "#{inspect queries}"
    Logger.debug "#{JSX.prettify! JSX.encode!(queries)}"
    queries
  end

end
