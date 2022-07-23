module JsonSchema::UserPlanDetail
  def self.schema
    {
      "type" => "object",
      "required" => [
        :name,
        UserPlan::CAPACITY::PERFORMANCE_METRICS_RETENTION_HOURS,
        UserPlan::CAPACITY::MAX_SAVED_SETTINGS_SIZE,
        UserPlan::CAPACITY::MAX_DEVICES_SIZE
      ],
      "properties" => {
        "name" => {"type" => "string" },
        UserPlan::CAPACITY::PERFORMANCE_METRICS_RETENTION_HOURS => {"type" => "integer" },
        UserPlan::CAPACITY::MAX_SAVED_SETTINGS_SIZE => {"type" => "integer" },
        UserPlan::CAPACITY::MAX_DEVICES_SIZE => {"type" => "integer" },
      }
    }
  end
end
