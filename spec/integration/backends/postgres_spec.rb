require "spec_helper"

describe Switches::Backends::Postgres do
  let(:backend_url) { ENV["DATABASE_URL"] }

  before do
    alice.clear
  end

  it_behaves_like "a backend"
end
