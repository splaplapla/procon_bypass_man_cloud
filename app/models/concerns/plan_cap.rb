module PlanCap
  include CanChangeUserPlan

  # @return [Integer]
  def performance_metrics_retention_hours
    plan_detail[UserPlan::CAPACITY::PERFORMANCE_METRICS_RETENTION_HOURS]
  end

  # @return [Integer]
  def max_saved_settings_size
    plan_detail[UserPlan::CAPACITY::MAX_SAVED_SETTINGS_SIZE]
  end

  # @return [Integer]
  def max_devices_size
    plan_detail[::UserPlan::CAPACITY::MAX_DEVICES_SIZE]
  end

  # @return [Integer]
  def max_splatoon2_sketches_size
    plan_detail[UserPlan::CAPACITY::MAX_SPLATOON2_SKETCHES_SIZE]
  end

  # @return [Symbol]
  def plan_name
    plan_detail[:name]
  end

  private

  def plan_detail
    UserPlan::DETAIL[plan]
  end
end
