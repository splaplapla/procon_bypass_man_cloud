class PbmJobFactory
  class ValidationError < StandardError; end

  INITIALIZED_STATUS = :queued

  def initialize(device_id: , action: nil, job_args: {})
    @device_id = device_id
    @pbm_job = Device.find(device_id).pbm_jobs.build
    @action = action
    @job_args = job_args
  end


  # @raise [ActiveRecord::RecordInvalid] when invalid
  def build
    attributes = default_attributes.dup.merge!(action: @action, args: @job_args)
    validate!(attributes)

    @pbm_job.assign_attributes(attributes)
    @pbm_job.validate!
    @pbm_job
  end

  private

  def default_attributes
    { action: nil,
      status: INITIALIZED_STATUS,
      uuid: PbmJob.generate_uuid,
      args: nil,
    }
  end

  # @param [Hash]
  def validate!(attributes)
    case attributes[:action]
    when :restore_pbm_setting
      unless attributes[:args].key?(:setting) && attributes[:args].key?(:setting_name)
        raise ValidationError, "invalid args(#{attributes})"
      end
    when :change_pbm_version
      unless attributes[:args].key?(:pbm_version)
        raise ValidationError, "invalid args(#{attributes})"
      end
    end

    if attributes[:status] != INITIALIZED_STATUS
      raise ValidationError, "invalid status(#{attributes})"
    end

    if attributes[:uuid].nil? || attributes[:uuid].empty?
      raise ValidationError, "invalid uuid(#{attributes})"
    end
  end
end
