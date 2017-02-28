class PlayNetworksController < ApplicationController
  before_action :set_play_network, only: [:show, :edit, :update, :destroy]
  before_action :get_params, only: :index

  # GET /play_networks
  # GET /play_networks.json
  def index
    if current_user.admin?
      @play_networks = PlayNetwork.all
    elsif current_user.parent?
      if @child
        EventLog.getPlayNetworks(current_user, nil, child1_id: @child.id)
        @play_networks = @child.play_networks
      else
        EventLog.getPlayNetworks(current_user)
        @play_networks = current_user.family.play_networks
      end
    else
      @play_networks = []
    end
  end

  # GET /play_networks/1
  # GET /play_networks/1.json
  def show
  end

  # GET /play_networks/new
  def new
    @play_network = PlayNetwork.new
  end

  # GET /play_networks/1/edit
  def edit
  end

  # POST /play_networks
  # POST /play_networks.json
  def create
    @play_network = PlayNetwork.new(play_network_params)

    respond_to do |format|
      if @play_network.save
        format.html { redirect_to @play_network, notice: 'Play network was successfully created.' }
        format.json { render :show, status: :created, location: @play_network }
      else
        format.html { render :new }
        format.json { render json: @play_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /play_networks/1
  # PATCH/PUT /play_networks/1.json
  def update
    respond_to do |format|
      if @play_network.update(play_network_params)
        format.html { redirect_to @play_network, notice: 'Play network was successfully updated.' }
        format.json { render :show, status: :ok, location: @play_network }
      else
        format.html { render :edit }
        format.json { render json: @play_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /play_networks/1
  # DELETE /play_networks/1.json
  def destroy
    @play_network.destroy
    respond_to do |format|
      format.html { redirect_to play_networks_url, notice: 'Play network was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_play_network
      @play_network = PlayNetwork.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def play_network_params
      params.require(:play_network).permit(:name)
    end

    def get_params
      @child_id = params[:child_id] || params[:child]
      @play_network_id = params[:play_network_id] || params[:play_network]
      if @child_id
        @child = Child.find(@child_id)
      end
    end
end
