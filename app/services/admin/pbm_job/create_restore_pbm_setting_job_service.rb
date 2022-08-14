class Admin::PbmJob::CreateRestorePbmSettingJobService
  # @param [Device] device
  # @param [SavedButtonsSetting] saved_buttons_setting
  def initialize(device: , setting_content: , setting_name: )
    @device = device
    @setting_content = setting_content
    @setting_name = setting_name
  end

  def execute!
    pbm_job = PbmJobFactory.new(
      device_id: @device.id,
      action: :restore_pbm_setting,
      job_args: { setting: @setting_content, setting_name: @setting_name },
    ).build
    pbm_job.save!
    pbm_job
  end
end
