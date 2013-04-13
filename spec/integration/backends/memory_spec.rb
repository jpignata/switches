require "spec_helper"

describe Switches::Backends::Redis do
  let(:backend_url) { "memory:///" }

  before do
    switches.clear
  end

  it_behaves_like "a backend"
end
