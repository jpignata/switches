require "spec_helper"
require "switches/backends/redis"

describe Switches::Backends::Redis do
  let(:backend_url) { ENV["REDIS_URL"] }

  it_behaves_like "a backend"
end
