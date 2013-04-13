require "spec_helper"
require "switches/backends/memory"

describe Switches::Backends::Memory do
  let(:backend_url) { "memory:///" }

  before do
    switches.clear
  end

  it_behaves_like "a backend"
end
