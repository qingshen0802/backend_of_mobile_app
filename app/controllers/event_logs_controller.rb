class EventLogsController < ApplicationController
  before_action :get_params

  # GET /event_logs
  # GET /event_logs.json
  def index
    if current_user.admin?
      @event_logs = EventLog.by_mode_type(@mode_type).by_event_type(@event_type).order('id DESC').paginate(:page => @page,:per_page => @per_page)
    else
      @event_logs = EventLog.by_initiator(current_user.supervisor).by_mode_type(@mode_type).by_event_type(@event_type).order('id DESC').paginate(:page => @page,:per_page => @per_page)
    end
  end

  # GET /event_logs
  # GET /event_logs.json
  def show
    if current_user.admin?
      @event_log = EventLog.find(params[:id])
    else
      @event_log = EventLog.by_initiator(current_user.supervisor).by_mode_type(@mode_type).by_event_type(@event_type).by_id(params[:id])
    end
  end

  private
    def get_params
      @event_type = params[:type]
      @mode_type = params[:mode]
      @page = params[:page]
      @per_page = params[:per_page]
      @per_page = 25 if @per_page.blank?
      @filter = {type: @event_type, page: @page, per_page: @per_page}
    end
end
