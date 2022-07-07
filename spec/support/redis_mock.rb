RSpec.shared_context 'redis_mock' do
  let(:redis) { MockRedis.new }

  before(:each) do
    allow(Redis).to receive(:new) { redis }
  end
end
