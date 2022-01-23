class Admin::PbmJob::CreateRestorePbmSettingJobService
  # @param [Device] device
  # @param [SavedButtonsSetting] saved_buttons_setting
  def initialize(device: , saved_buttons_setting: )
    @device = device
    @saved_buttons_setting = saved_buttons_setting
  end

  def execute!
    pbm_job = PbmJobFactory.new(
      device_id: @device.id,
      action: :restore_pbm_setting,
      job_args: { content: @saved_buttons_setting.content, setting_name: @saved_buttons_setting.name },
    ).build
    pbm_job.save!
    pbm_job
  end
end
