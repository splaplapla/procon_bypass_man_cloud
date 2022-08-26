class Api::CompletedPbmRemoteMacroJobsController < Api::Base
  def create
    device = get_device
    pbm_remote_macro_job = device.pbm_remote_macro_jobs.find_by!(uuid: params[:job_id])
    pbm_remote_macro_job.update!(status: :processed)

    render json: PbmRemoteMacroJobSerializer.new(pbm_remote_macro_job)
  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: "the remote_macro_job(#{params[:job_id]}) did not find" }, status: :bad_request
  rescue ActiveModel::ValidationError => e
    render json: { errors: e.model.errors.full_messages }, status: :bad_request
  end
end
