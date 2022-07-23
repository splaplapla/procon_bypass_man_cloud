require 'rails_helper'

RSpec.describe UserPlan, type: :model do
  describe 'json-schema' do
    UserPlan::DETAIL.each do |plan, detail|
      it "#{UserPlan::DETAIL[plan][:name]}" do
      expect(JSON::Validator.validate(JsonSchema::UserPlanDetail.schema, detail)).to eq(true)
    end
    end
  end
end
