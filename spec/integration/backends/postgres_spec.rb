require "spec_helper"

describe Switches::Backends::Postgres do
  let(:backend_url) { "postgres://jp:@localhost/switches" }

  before do
    alice.clear
  end

  it_behaves_like "a backend"
end
