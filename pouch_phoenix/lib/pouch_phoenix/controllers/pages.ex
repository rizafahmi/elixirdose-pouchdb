defmodule PouchPhoenix.Controllers.Pages do
  use Phoenix.Controller

  def index(conn) do
    # text conn, "Hello world"
    html conn, File.read!(Path.join(["priv/views/index.html"]))
  end
end
