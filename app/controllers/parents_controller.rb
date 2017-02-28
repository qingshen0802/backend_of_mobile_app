class ParentsController < ApplicationController
  before_action :set_parent, only: [:show, :edit, :update, :destroy]
  before_action :calculate_parent_details, only: :show
  before_action :get_form_collections, only: [:new, :edit, :update, :create]

  # GET /parents
  # GET /parents.json
  def index
    if current_user.admin?
      @parents = Parent.all
    elsif current_user.parent?
      @parents = current_user.parent.family.parents
    else
      @parents = []
    end
  end

  # GET /parents/1
  # GET /parents/1.json
  def show
  end

  # GET /parents/new
  def new
    @parent = Parent.new(family: @family)
  end

  # GET /parents/1/edit
  def edit
  end

  # POST /parents
  # POST /parents.json
  def create
    @parent = Parent.new(parent_params)

    respond_to do |format|
      if @parent.save
        format.html { redirect_to @parent.family, notice: 'Parent was successfully created.' }
        format.json { render :show, status: :created, location: @parent }
      else
        format.html { render :new }
        format.json { render json: @parent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parents/1
  # PATCH/PUT /parents/1.json
  def update
    respond_to do |format|
      if @parent.update(parent_params)
        format.html { redirect_to @parent.family, notice: 'Parent was successfully updated.' }
        format.json { render :show, status: :ok, location: @parent }
      else
        format.html { render :edit }
        format.json { render json: @parent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parents/1
  # DELETE /parents/1.json
  def destroy
    @family = @parent.family
    @parent.destroy
    respond_to do |format|
      format.html { redirect_to @family, notice: 'Parent was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def get_form_collections
      @families = Family.all
      @family = Family.find(params[:family_id]) if params[:family_id]
      @users = User.supervisors_and_parents
      @apps = App.all
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_parent
      @parent = Parent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parent_params
      params.require(:parent).permit(:first_name, :last_name, :family_id, :user_id, :user_name, :user_email, :user_password, :user_password_confirmation)
    end
end
