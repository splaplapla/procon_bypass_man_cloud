class Cron::DeleteOldSessionsPerDevice
  def self.execute!
    PbmSession.where("updated_at < ?", 5.days.ago).find_each(&:destroy) # 更新し続けている場合は消さない
    PbmJob.where("created_at < ?", 5.days.ago).find_each(&:destroy)
    PbmRemoteMacroJob.where("created_at < ?", 5.days.ago).find_each(&:destroy)
    ActsAsTaggableOn::Tag.where(taggings_count: 0).each(&:destroy)
  end
end
