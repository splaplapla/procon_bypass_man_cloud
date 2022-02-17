require 'rails_helper'

RSpec.describe "Internal::ProconBypassManVersions", type: :request do
  describe 'GET /show' do
    it do
      get internal_procon_bypass_man_version_path(id: 1)
    end
  end
end
