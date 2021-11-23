class PbmJobSerializer
  include ActiveModel::Serializers::JSON

  attr_accessor :action, :status, :uuid

  def initialize(pbm_job)
    self.action = pbm_job.action
    self.status = pbm_job.status
    self.uuid = pbm_job.uuid
  end

  def attributes
    { action: action, status: status, uuid: uuid }
  end
end
