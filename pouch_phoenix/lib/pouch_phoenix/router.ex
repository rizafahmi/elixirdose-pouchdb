defmodule PouchPhoenix.Router do
  use Phoenix.Router

  plug Plug.Static, at: "/static", from: :pouch_phoenix
  get "/", PouchPhoenix.Controllers.Pages, :index, as: :page
end
