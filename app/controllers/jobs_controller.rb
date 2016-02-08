class JobsController < ApplicationController
  before_action :set_job, only: [:status, :result]

  # POST /crawls
  # POST /crawls.json
  def create

    @job = Job.new_with_urls(url_params)

    if @job.save
      render json: { job_id: @job.id }, status: :accepted
    else
      render json: { errors: @job.errors}, status: :unprocessable_entity
    end
  end

  def status
    render json: {
      completed: @job.crawls.where(in_progress: false).count,
      inprogress: @job.crawls.where(in_progress: true).count
    }, status: :ok
  end

  def result
    result = Hash.new
    @job.crawls.each do |crawl|
      result[crawl.url] = crawl.images
    end
    render json: result, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.includes(:crawls).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_params
      params.require(:urls)
    end
end
