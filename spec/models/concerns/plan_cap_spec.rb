require 'rails_helper'

RSpec.describe PlanCap, type: :model do
  let(:has_plan) do
    Class.new {
      include PlanCap

      def plan; end
    }.new
  end

  before do
    allow(has_plan).to receive(:plan) { plan_value }
  end

  context 'free' do
    let(:plan_value) { UserPlan::PLAN::PLAN_FREE }

    it do
      expect(has_plan.max_saved_settings_size).to eq(5)
    end

    it do
      expect(has_plan.performance_metrics_retention_hours).to eq(2)
    end
  end

  context 'pro' do
    let(:plan_value) { UserPlan::PLAN::PLAN_PRO }

    it do
      expect(has_plan.max_saved_settings_size).to eq(40)
    end

    it do
      expect(has_plan.performance_metrics_retention_hours).to eq(10)
    end
  end
end
