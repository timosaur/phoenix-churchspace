use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :churchspace, Churchspace.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :churchspace, Churchspace.Repo,
  adapter: Ecto.Adapters.Postgres,
  extensions: [{Ecto.Extensions.Ltree, []}],
  username: "postgres",
  password: "postgres",
  database: "churchspace_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
