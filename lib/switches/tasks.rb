require "switches"
require "switches/backends/postgres/tasks/setup"
require "switches/backends/postgres/tasks/remove"

namespace :switches do
  namespace :postgres do
    desc "Setup Switches PostgreSQL table"
    task :setup do
      database_url = ENV["DATABASE_URL"]

      unless database_url
        abort "DATABASE_URL required. (e.g. postgres://user:password@hostname:port/dbname)"
      end

      connection = Switches::Backends::Postgres::Connection.new(database_url)
      task = Switches::Backends::Postgres::Setup.new(connection)
      task.run
    end

    desc "Remove Switches PostgreSQL table"
    task :remove do
      database_url = ENV["DATABASE_URL"]

      unless database_url
        abort "DATABASE_URL required. (e.g. postgres://user:password@hostname:port/dbname)"
      end

      connection = Switches::Backends::Postgres::Connection.new(database_url)
      task = Switches::Backends::Postgres::Remove.new(connection)
      task.run
    end
  end
end
