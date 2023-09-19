defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line intefarface for `Issues`.
  """
  def run(argv), do: parse_args(argv)

  def parse_args(argv) do
    OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help, v: :version]
    )
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]),
    do: {user, project, count |> String.to_integer()}

  def args_to_internal_representation([user, project]), do: {user, project, @default_count}
  def args_to_internal_representation(_), do: :help
end
