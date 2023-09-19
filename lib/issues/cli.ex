defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line intefarface for `Issues`.
  """
  def run(argv), do: parse_args(argv)

  def parse_args(argv) do
    parse =
      OptionParser.parse(argv,
        switches: [help: :boolean],
        aliases: [h: :help, v: :version]
      )

    case parse do
      {[help: true], _, _} ->
        :help

      {_, [user, project, count], _} ->
        {user, project, count}

      {_, [user, project], _} ->
        {user, project, @default_count}

      _ ->
        :help
    end
  end
end
