class PbmJobFactory
  def initialize(device_id: )
    @device_id = device_id
    @pbm_job = Device.find(device_id).pbm_jobs.build
  end

  def build
    attributes = default_attributes.dup
    attributes.merge!(args: @pbm_job.args) if @pbm_job.args.present?
    attributes.merge!(action: @pbm_job.action) if @pbm_job.action.present?

    @pbm_job.assign_attributes(attributes)
    @pbm_job
  end

  def args=(val)
    @pbm_job.args = val
  end

  def action=(val)
    @pbm_job.action = val
  end

  private

  def default_attributes
    { action: :change_pbm_version,
      status: :queued,
      uuid: SecureRandom.uuid,
      args: {},
    }
  end
end
