class PlayNodesController < ApplicationController
  before_action :set_play_node, only: [:show, :edit, :update, :destroy]
  before_action :get_form_collections, only: [:new, :edit, :update]

  # GET /play_nodes
  # GET /play_nodes.json
  def index
    @play_network = PlayNetwork.find(params[:play_network_id]) if params[:play_network_id]
    @play_nodes = @play_network ? @play_network.play_nodes : PlayNode.all
  end

  # GET /play_nodes/1
  # GET /play_nodes/1.json
  def show
  end

  # GET /play_nodes/new
  def new
    @play_node = PlayNode.new(play_network_id: params[:play_network_id])
  end

  # GET /play_nodes/1/edit
  def edit
  end

  # POST /play_nodes
  # POST /play_nodes.json
  def create
    @play_node = PlayNode.new(play_node_params)

    respond_to do |format|
      if @play_node.save
        format.html { redirect_to @play_node.play_network, notice: 'Play node was successfully created.' }
        format.json { render :show, status: :created, location: @play_node }
      else
        format.html { render :new }
        format.json { render json: @play_node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /play_nodes/1
  # PATCH/PUT /play_nodes/1.json
  def update
    respond_to do |format|
      if @play_node.update(play_node_params)
        format.html { redirect_to @play_node.play_network, notice: 'Play node was successfully updated.' }
        format.json { render :show, status: :ok, location: @play_node }
      else
        format.html { render :edit }
        format.json { render json: @play_node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /play_nodes/1
  # DELETE /play_nodes/1.json
  def destroy
    play_network = @play_node.play_network
    @play_node.destroy
    respond_to do |format|
      format.html { redirect_to play_network, notice: 'Play node was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def get_form_collections
      @play_networks = PlayNetwork.all
      @children = Child.all
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_play_node
      @play_node = PlayNode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def play_node_params
      params.require(:play_node).permit(:child_id, :play_network_id)
    end
end
