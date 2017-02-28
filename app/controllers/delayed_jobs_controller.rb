class DelayedJobsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_delayed_job, only: [:show]
  before_action :get_params, only: [:index]

  # GET /delayed_jobs
  # GET /delayed_jobs.json
  def index
    if @type == 'queued'
      @delayed_jobs = DelayedJob.where(run_at: nil).order('id DESC').paginate(:page => @page,:per_page => @per_page)
    elsif @type == 'run'
      @delayed_jobs = DelayedJob.where.not(run_at: nil).order('id DESC').paginate(:page => @page,:per_page => @per_page)
    elsif @type == 'failed'
      @delayed_jobs = DelayedJob.where.not(last_error: nil).order('id DESC').paginate(:page => @page,:per_page => @per_page)
    elsif @type == 'success'
      @delayed_jobs = DelayedJob.where(last_error: nil).order('id DESC').paginate(:page => @page,:per_page => @per_page)
    else
      @delayed_jobs = DelayedJob.all.order('id DESC').paginate(:page => @page,:per_page => @per_page)
    end
  end

  # GET /delayed_jobs/1
  # GET /delayed_jobs/1.json
  def show
  end

  private
    def authenticate_admin!
      user_signed_in? && current_user.admin?
    end

    def get_params
      @type = params[:type]
      @page = params[:page]
      @per_page = params[:per_page]
      if @per_page.blank?
        @per_page = @timestamp ? 10000 : 10
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_delayed_job
      @delayed_job = DelayedJob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def delayed_job_params
      params[:delayed_job]
    end
end
