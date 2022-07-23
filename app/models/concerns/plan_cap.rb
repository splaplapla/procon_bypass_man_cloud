module PlanCap
  def performance_metrics_retention_hours
    plan_detail[:performance_metrics_retention_hours]
  end

  def max_saved_settings_size
    plan_detail[:max_saved_settings_size]
  end

  def plan_name
    plan_detail[:name]
  end

  private

  def plan_detail
    UserPlan::DETAIL[plan]
  end
end
