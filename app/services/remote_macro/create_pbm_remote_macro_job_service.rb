class RemoteMacro::CreatePbmRemoteMacroJobService
  def initialize(device: , save_record: true)
    @device = device
    @save_record = save_record
  end

  def execute(name: , steps: )
    raise "need steps" if steps.nil?

    remote_macro_job = @device.pbm_remote_macro_jobs.build(
      name: name.presence || "入力なし",
      status: :queued,
      steps: split_steps(steps),
      uuid: PbmRemoteMacroJob.generate_uuid,
    )
    remote_macro_job.save! if @save_record
    remote_macro_job
  end

  private

  def split_steps(steps)
    if /^\[(.+)\]$/ =~ steps
      steps = $1
    end

    steps.split(/[,\s]+/).map { |x| x.remove(/^:/) }
  end
end
