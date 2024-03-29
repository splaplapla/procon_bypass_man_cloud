module UserPlan
  module PLAN
    PLAN_FREE = 0
    PLAN_LIGHT = 1
    PLAN_STANDARD = 2
    PLAN_PRO = 3
  end

  module CAPACITY
    PERFORMANCE_METRICS_RETENTION_HOURS = :performance_metrics_retention_hours
    MAX_SAVED_SETTINGS_SIZE = :max_saved_settings_size
    MAX_DEVICES_SIZE = :max_devices_size
    MAX_SPLATOON2_SKETCHES_SIZE = :max_splatoon2_sketches_size
  end

  DETAIL = {
    PLAN::PLAN_FREE => {
      name: :free,
      CAPACITY::PERFORMANCE_METRICS_RETENTION_HOURS => 2,
      CAPACITY::MAX_SAVED_SETTINGS_SIZE => 3,
      CAPACITY::MAX_DEVICES_SIZE => 2,
      CAPACITY::MAX_SPLATOON2_SKETCHES_SIZE => 2,
    },
    PLAN::PLAN_LIGHT => {
      name: :light,
      CAPACITY::PERFORMANCE_METRICS_RETENTION_HOURS => 5,
      CAPACITY::MAX_SAVED_SETTINGS_SIZE => 10,
      CAPACITY::MAX_DEVICES_SIZE => 3,
      CAPACITY::MAX_SPLATOON2_SKETCHES_SIZE => 5,
    },
    PLAN::PLAN_STANDARD => {
      name: :standard,
      CAPACITY::PERFORMANCE_METRICS_RETENTION_HOURS => 20,
      CAPACITY::MAX_SAVED_SETTINGS_SIZE => 20,
      CAPACITY::MAX_DEVICES_SIZE => 4,
      CAPACITY::MAX_SPLATOON2_SKETCHES_SIZE => 10,
    },
    PLAN::PLAN_PRO => {
      name: :pro,
      CAPACITY::PERFORMANCE_METRICS_RETENTION_HOURS => 20,
      CAPACITY::MAX_SAVED_SETTINGS_SIZE => 40,
      CAPACITY::MAX_DEVICES_SIZE => 10,
      CAPACITY::MAX_SPLATOON2_SKETCHES_SIZE => 15,
    },
  }
end
