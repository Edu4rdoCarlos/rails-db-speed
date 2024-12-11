# Puma can serve each request in a thread from an internal thread pool.
workers ENV.fetch("WEB_CONCURRENCY") { 2 }
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Especifique as portas que o Puma deve escutar
port_3000 = ENV.fetch("PORT_3000") { 3000 }
port_3001 = ENV.fetch("PORT_3001") { 3001 }

# Configure os binds
bind "tcp://0.0.0.0:#{port_3000}"
bind "tcp://0.0.0.0:#{port_3001}"

# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
