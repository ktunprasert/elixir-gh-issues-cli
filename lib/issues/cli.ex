defmodule Issues.CLI do
  @default_count 4

  import Issues.TableFormatter, only: [print_table_for_columns: 2]

  @moduledoc """
  Handle the command line intefarface for `Issues`.
  """
  def main(argv), do: argv |> parse_args |> process

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

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_issues()
    |> Enum.take(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def sort_issues(issues_list, opts \\ [{:order, :desc}, {:field, "created_at"}]) do
    order = opts[:order] || :desc
    field = opts[:field] || "created_at"

    issues_list |> Enum.sort_by(fn issue -> issue[field] end, order)
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
