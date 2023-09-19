defmodule Issues.GithubIssues do
  def fetch(user, project) do
    HTTPoison.get("https://api.github.com/repos/#{user}/#{project}/issues")
  end
end
