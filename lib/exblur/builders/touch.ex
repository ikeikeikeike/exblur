defmodule Exblur.Builders.Touch do
  import Exblur.Builders.Base

  def run, do: run []
  def run([]) do
    System.cmd("touch", ["/tmp/_exblur"])
  end

end
