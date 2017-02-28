class Api::V1::InfosController < Api::BaseController
  protect_from_forgery with: :null_session
  
  before_action :get_params, only: [:index, :last]
  before_action :set_info, only: [:show, :edit, :update, :destroy]
  before_action :read_infos, only: [:index, :last]
  respond_to :json

  # GET /infos
  # GET /infos.json
  def index
    EventLog.getInfos(current_user)
  end

  # GET /api/info
  # GET /api/info
  # GET /api/info/1.json
  def last
    EventLog.getLastInfo(current_user, @info)
    render json: @infos.first.as_json(), status: 200
  end

  # GET /infos/1
  # GET /infos/1.json
  def show
  end

  # GET /infos/new
  def new
    @info = Info.new
  end

  # GET /infos/1/edit
  def edit
  end

  # POST /infos
  # POST /infos.json
  def create
    @info = Info.new(info_params)

    if @info.save
      render :show, status: :created, location: @info
    else
      render json: @info.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /infos/1
  # PATCH/PUT /infos/1.json
  def update
    if @info.update(info_params)
      render :show, status: :ok, location: @info
    else
      render json: @info.errors, status: :unprocessable_entity
    end
  end

  # DELETE /infos/1
  # DELETE /infos/1.json
  def destroy
    @info.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_info
      @info = Info.find(params[:id])
    end

    def read_infos
      if current_user.admin?
        @infos = Info.all.by_message_type(@message_types).by_display_type(@display_type).recent.after(@timestamp).paginate(:page => @page,:per_page => @per_page).to_a
      elsif current_user.parent?
        @infos = current_user.parent.infos_by_type(@message_types).by_display_type(@display_type).recent.after(@timestamp).paginate(:page => @page,:per_page => @per_page).to_a
      elsif current_user.supervisor?
        @infos = current_user.supervisor.infos_by_type(@message_types).by_display_type(@display_type).recent.after(@timestamp).paginate(:page => @page,:per_page => @per_page).to_a
      else
        @infos = []
      end
      @infos.each{|i| i.mark_delivered!} if !@infos.blank? && @mobile_device
    end

    def get_params
      @mobile_device = params[:device] || params[:device_id]
      @display_type = params[:display_type]
      @message_type = params[:types] || params[:type]
      @message_types = @message_type && @message_type.include?(',') ? @message_type.split(',') : @message_type
      @page = params[:page]
      @timestamp = params[:timestamp].blank? ? nil : Time.at(params[:timestamp].to_i)
      @per_page = !params[:per_page].blank? ? params[:per_page] : (params[:action] == 'last') ? 1 : @timestamp ? 10000 : 10
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def info_params
      params.require(:info).permit(:message_type, :timestamp, :received_at, :app_id, :playcelet_id)
    end
end
