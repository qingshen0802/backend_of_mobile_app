class InfosController < ApplicationController
  before_action :set_info, only: [:show, :edit, :update, :destroy]
  before_action :get_params, only: [:index, :last]

  # GET /infos
  # GET /infos.json
  def index
    if current_user.admin?
      @infos = Info.all.by_message_type(@message_types).by_display_type(@display_type).recent.after(@timestamp).paginate(:page => @page,:per_page => @per_page)
    elsif current_user.parent?
      @infos = current_user.parent.infos_by_type(@message_types).by_display_type(@display_type).recent.after(@timestamp).paginate(:page => @page,:per_page => @per_page)
    elsif current_user.supervisor?
      @infos = current_user.supervisor.infos_by_type(@message_types).by_message_type(@message_types).by_display_type(@display_type).recent.after(@timestamp).paginate(:page => @page,:per_page => @per_page)
    else
      @infos = []
    end
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

    respond_to do |format|
      if @info.save
        format.html { redirect_to @info, notice: 'Info was successfully created.' }
        format.json { render :show, status: :created, location: @info }
      else
        format.html { render :new }
        format.json { render json: @info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /infos/1
  # PATCH/PUT /infos/1.json
  def update
    respond_to do |format|
      if @info.update(info_params)
        format.html { redirect_to @info, notice: 'Info was successfully updated.' }
        format.json { render :show, status: :ok, location: @info }
      else
        format.html { render :edit }
        format.json { render json: @info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /infos/1
  # DELETE /infos/1.json
  def destroy
    @info.destroy
    respond_to do |format|
      format.html { redirect_to infos_url, notice: 'Info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def get_params
      @message_type = params[:types] || params[:type]
      @display_type = params[:display_type]
      @message_types = @message_type && @message_type.include?(',') ? @message_type.split(',') : @message_type
      @page = params[:page]
      @timestamp = params[:timestamp].blank? ? nil : Time.at(params[:timestamp].to_i)
      @per_page = params[:per_page]
      if @per_page.blank?
        @per_page = @timestamp ? 10000 : 10
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_info
      @info = Info.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def info_params
      params.require(:info).permit(:message_type, :timestamp, :received_at, :app_id, :playcelet_id)
    end
end
