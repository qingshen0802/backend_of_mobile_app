class RegistrationsController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :calculate_user_details, only: [:show, :edit, :update]

  # GET /registrations
  # GET /registrations.json
  def index
    @users = User.all
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
  end

  # GET /registrations/new
  def new
    @user = User.new
  end

  # GET /registrations/1/edit
  def edit
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to registration_path(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to registrations_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to registrations_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if params[:user] && params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
        clean_params(params).require(:user).permit(:name, :email, :time_zone)
      else
        clean_params(params).require(:user).permit(:name, :email, :time_zone, :password, :password_confirmation)
      end
    end

    def clean_params(params)
      ActionController::Parameters.new(params)
    end
end
