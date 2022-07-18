module UserPlan
  module PLAN
    PLAN_FREE = 0
    PLAN_LIGHT = 1
    PLAN_STANDARD = 2
    PLAN_PRO  = 3

    module CAPACITY
      PERFORMANCE_METRICS_RETENTION_HOURS = :performance_metrics_retention_hours
      MAX_SAVED_SETTINGS_SIZE = :max_saved_settings_size

      DETAIL = {
        PLAN_FREE => {
          PERFORMANCE_METRICS_RETENTION_HOURS => 2,
          MAX_SAVED_SETTINGS_SIZE => 5,
        },
        PLAN_LIGHT => {
          PERFORMANCE_METRICS_RETENTION_HOURS => 5,
          MAX_SAVED_SETTINGS_SIZE => 10,
        },
        PLAN_STANDARD => {
          PERFORMANCE_METRICS_RETENTION_HOURS => 10,
          MAX_SAVED_SETTINGS_SIZE => 20,
        },
        PLAN_PRO => {
          PERFORMANCE_METRICS_RETENTION_HOURS => 10,
          MAX_SAVED_SETTINGS_SIZE => 40,
        },
      }
    end
  end
end
