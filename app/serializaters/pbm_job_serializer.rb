class PbmJobSerializer
  include ActiveModel::Serializers::JSON

  attr_accessor :action, :status, :uuid, :created_at, :args

  def initialize(pbm_job)
    self.action = pbm_job.action
    self.status = pbm_job.status
    self.uuid = pbm_job.uuid
    self.args = pbm_job.args
    self.created_at = pbm_job.created_at
  end

  def attributes
    { action: action,
      status: status,
      uuid: uuid,
      args: args,
      created_at: created_at,
    }
  end
end
