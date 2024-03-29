class PbmRemoteMacroJobSerializer
  attr_accessor :action, :status, :name, :uuid, :steps, :created_at

  def initialize(remote_macro_job)
    self.action = 'remote_macro' # ProconBypassMan::RemoteMacro::ACTION_KEY
    self.status = remote_macro_job.status
    self.name = remote_macro_job.name
    self.uuid = remote_macro_job.uuid
    self.steps = remote_macro_job.steps
    self.created_at = remote_macro_job.created_at
  end

  def attributes
    { action: action,
      status: status,
      name: name,
      uuid: uuid,
      steps: steps,
      created_at: created_at,
    }
  end
end
