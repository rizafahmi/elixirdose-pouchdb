defmodule Router do
  use Sugar.Router, plugs: [
      { Sugar.Plugs.HotCodeReload, [] },
      { Plug.Static, at: "/static", from: :sugar_pouchdb },

      # Uncomment the following line for session store
      # { Plug.Session, store: :ets, key: "sid", secure: true, table: :session },

      # Uncomment the following line for request logging,
      # and add 'applications: [:exlager],' to the application
      # Keyword list in your mix.exs
      # { Sugar.Plugs.Logger, [] }
  ]

  # Define your routes here
  get "/", SugarPouchdb.Controllers.Main, :index
end
