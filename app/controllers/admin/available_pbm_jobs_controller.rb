class Admin::AvailablePbmJobsController < Admin::Base
  def index
    @device = Device.find(params[:device_id])
    @selectable_pbm_versions = SupportPbmVersion.versions.map do |version|
      if @device.pbm_version == version
        "#{version}(now)"
      else
        version
      end
    end
  end
end
