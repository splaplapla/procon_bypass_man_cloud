class Cron::DeleteOldSessionsPerDevice
  def self.execute!
    PbmSession.where("created_at < ?", 5.days.ago).find_each(&:destroy)
    PbmJob.where("created_at < ?", 5.days.ago).find_each(&:destroy)
    PbmRemoteMacroJob.where("created_at < ?", 5.days.ago).find_each(&:destroy)
    ActsAsTaggableOn::Tag.where(taggings_count: 0).each(&:destroy)
  end
end
