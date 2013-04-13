require "spec_helper"
require "switches/backends/postgres"

describe Switches::Backends::Postgres do
  let(:backend_url) { ENV["DATABASE_URL"] }

  it_behaves_like "a backend"
end
