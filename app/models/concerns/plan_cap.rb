module PlanCap
  def performance_metrics_retention_hours
    plan_detail[UserPlan::CAPACITY::PERFORMANCE_METRICS_RETENTION_HOURS]
  end

  def max_saved_settings_size
    plan_detail[UserPlan::CAPACITY::MAX_SAVED_SETTINGS_SIZE]
  end

  def max_devices_size
    plan_detail[UserPlan::CAPACITY::MAX_DEVICES_SIZE]
  end

  def plan_name
    plan_detail[:name]
  end

  private

  def plan_detail
    UserPlan::DETAIL[plan]
  end
end
