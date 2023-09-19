defmodule Issues.GithubIssues do
  @github_url Application.compile_env(:issues, :github_url, "https://api.github.com")

  def fetch(user, project) do
    HTTPoison.get(issues_url(user, project))
    |> handle_response()
  end

  def handle_response({_, %{status_code: code, body: body}}) do
    {code |> check_for_error(), body |> Poison.Parser.parse!()}
  end

  def check_for_error(200), do: :ok
  def check_for_error(_), do: :error

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end
end
