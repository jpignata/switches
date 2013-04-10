require "spec_helper"

describe Backends::Redis do
  let(:backend_url) { "memory:///" }

  before do
    switches = Switches do |config|
      config.backend = backend_url
    end

    switches.clear
  end

  it_behaves_like "a backend"
end
