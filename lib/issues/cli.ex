defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line intefarface for `Issues`.
  """
  def run(argv), do: argv |> parse_args |> process

  def process(:help) do
    IO.puts("""
      usage: issues <user> <project> [count]
      where:
        <user> is a GitHub user name
        <project> is a GitHub project name
        [count] is an optional number of issues to display (default #{@default_count})
    """)

    System.halt(0)
  end

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project) |> decode_response
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching issues from Github: #{error["message"]}")
    System.halt(2)
  end

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
