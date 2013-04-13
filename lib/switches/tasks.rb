require "switches"
require "switches/backends/postgres/tasks/setup"
require "switches/backends/postgres/tasks/remove"

namespace :switches do
  namespace :postgres do
    task :database do
      database_url = ENV["DATABASE_URL"]

      unless database_url
        abort "DATABASE_URL required. (e.g. postgres://user:password@hostname:port/dbname)"
      end

      @connection = Switches::Backends::Postgres::Connection.new(database_url)
    end

    desc "Setup Switches PostgreSQL table"
    task setup: :database do
      Switches::Backends::Postgres::Setup.new(@connection).run
    end

    desc "Remove Switches PostgreSQL table"
    task remove: :database do
      Switches::Backends::Postgres::Remove.new(@connection).run
    end
  end
end
