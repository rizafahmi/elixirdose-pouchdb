defmodule SugarPouchdb.Controllers.Main do
  use Sugar.Controller

  def index(conn, []) do
    render conn, "main/index.html.eex"
  end
end
