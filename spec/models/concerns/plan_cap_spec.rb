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

    it { expect(has_plan.max_saved_settings_size).to eq(3) }
    it { expect(has_plan.performance_metrics_retention_hours).to eq(2) }
    it { expect(has_plan.max_devices_size).to eq(2) }
    it { expect(has_plan.plan_name).to eq(:free) }
  end

  context 'pro' do
    let(:plan_value) { UserPlan::PLAN::PLAN_PRO }

    it { expect(has_plan.max_saved_settings_size).to eq(40) }
    it { expect(has_plan.performance_metrics_retention_hours).to eq(20) }
    it { expect(has_plan.max_devices_size).to eq(10) }
    it { expect(has_plan.plan_name).to eq(:pro) }
  end
end
