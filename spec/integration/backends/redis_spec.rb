require "spec_helper"

describe Switches::Backends::Redis do
  let(:backend_url) { "redis://localhost:6379/15" }

  before do
    switches.clear
  end

  it_behaves_like "a backend"
end
