defmodule SugarPouchdb.Repos.Main do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env

  @doc "Adapter configuration"
  def conf(env), do: parse_url url(env)

  @doc "The URL to reach the database."
  defp url(:dev) do
    "ecto://user:pass@localhost/sugar_pouchdb_main_dev"
  end

  defp url(:test) do
    "ecto://user:pass@localhost/sugar_pouchdb_main_test?size=1&max_overflow=0"
  end

  defp url(:prod) do
    "ecto://user:pass@localhost/sugar_pouchdb_main_prod"
  end

  @doc "The priv directory to load migrations and metadata."
  def priv do
    app_dir(:sugar_pouchdb, "priv/main")
  end
end
