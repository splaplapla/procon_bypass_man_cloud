class Cron::DeleteOldSessionsPerDevice
  def self.execute!
    PbmSession.where("created_at < ?", 5.days.ago).find_each(&:destroy)
  end
end
