require "spec_helper"
require "switches/backends/memory"

describe Switches::Backends::Memory do
  let(:backend_url) { "memory:///" }

  it_behaves_like "a backend"
end
