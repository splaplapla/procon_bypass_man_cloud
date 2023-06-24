require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /terms" do
    it do
      get terms_path
      expect(response).to be_ok
    end
  end

  describe "GET /faq" do
    it do
      get faq_path
      expect(response).to be_ok
    end
  end
end
