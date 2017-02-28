class ChildrenController < ApplicationController
  before_action :set_child, only: [:show, :edit, :update, :destroy]
  before_action :get_form_collections, only: [:new, :edit, :update, :create]

  # GET /children
  # GET /children.json
  def index
    if current_user.admin?
      @children = Child.all
    elsif current_user.parent?
      @children = current_user.parent.family.children
    else
      @children = []
    end
  end

  # GET /children/1
  # GET /children/1.json
  def show
  end

  # GET /children/new
  def new
    @child = Child.new(family: @family)
  end

  # GET /children/1/edit
  def edit
  end

  # POST /children
  # POST /children.json
  def create
    @child = Child.new(child_params)

    respond_to do |format|
      if @child.save
        EventLog.createChild(current_user, @child)
        format.html { redirect_to @child.family, notice: 'Child was successfully created.' }
        format.json { render :show, status: :created, location: @child }
      else
        format.html { render :new }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /children/1
  # PATCH/PUT /children/1.json
  def update
    respond_to do |format|
      if @child.update(child_params)
        EventLog.updateChild(current_user, @child, child_params)
        format.html { redirect_to @child.family, notice: 'Child was successfully updated.' }
        format.json { render :show, status: :ok, location: @child }
      else
        format.html { render :edit }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /children/1
  # DELETE /children/1.json
  def destroy
    EventLog.destroyChild(current_user, @child)
    @family = @child.family
    @child.destroy
    respond_to do |format|
      format.html { redirect_to @family, notice: 'Child was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def get_form_collections
      @family = Family.find(params[:family_id]) if params[:family_id]
      @families = Family.all
      @play_networks = @child ? @child.play_networks : []
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_child
      @child = Child.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def child_params
      params.require(:child).permit(:first_name, :last_name, :family_id, :playcelet, :color, :mac_address, :default_play_network_id)
    end
end
