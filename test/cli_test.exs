defmodule Issues.CLITest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort descending order correctly" do
    result = sort_issues(fake_list([1, 2, 3]), order: :desc)
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == [3, 2, 1]
  end

  test "sort ascending order correctly" do
    result = sort_issues(fake_list([5, 4, 3]), order: :asc)
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == [3, 4, 5]
  end

  defp fake_list(values) do
    for value <- values, do: %{"created_at" => value, "other_data" => "xxx"}
  end
end
