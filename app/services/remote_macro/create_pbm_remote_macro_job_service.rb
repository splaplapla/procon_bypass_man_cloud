class RemoteMacro::CreatePbmRemoteMacroJobService
  def initialize(device: )
    @device = device
  end

  def execute(name: , steps: )
    raise "need steps" if steps.nil?

    remote_macro_job = @device.pbm_remote_macro_jobs.build(
      name: name.presence || "入力なし",
      status: :queued,
      steps: split_steps(steps),
      uuid: PbmRemoteMacroJob.generate_uuid,
    )
    remote_macro_job.save!
    remote_macro_job
  end

  private

  def split_steps(steps)
    steps.split(/[,\s]+/)
  end
end
