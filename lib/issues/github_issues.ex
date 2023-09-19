defmodule Issues.GithubIssues do
  @github_url Application.compile_env(:issues, :github_url, "https://api.github.com")

  def fetch(user, project) do
    HTTPoison.get(issues_url(user, project))
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end
end
