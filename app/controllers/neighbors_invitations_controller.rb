class NeighborsInvitationsController < ApplicationController
  before_action :set_neighbors_invitation, only: [:show, :edit, :update, :destroy]

  # GET /neighbors_invitations
  # GET /neighbors_invitations.json
  def index
    @neighbors_invitations = NeighborsInvitation.all
  end

  # GET /neighbors_invitations/1
  # GET /neighbors_invitations/1.json
  def show
  end

  # GET /neighbors_invitations/new
  def new
    @neighbors_invitation = NeighborsInvitation.new
  end

  # GET /neighbors_invitations/1/edit
  def edit
  end

  # POST /neighbors_invitations
  # POST /neighbors_invitations.json
  def create
    @neighbors_invitation = NeighborsInvitation.new(neighbors_invitation_params)

    respond_to do |format|
      if @neighbors_invitation.save
        format.html { redirect_to @neighbors_invitation, notice: 'Neighbors invitation was successfully created.' }
        format.json { render :show, status: :created, location: @neighbors_invitation }
      else
        format.html { render :new }
        format.json { render json: @neighbors_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /neighbors_invitations/1
  # PATCH/PUT /neighbors_invitations/1.json
  def update
    respond_to do |format|
      if @neighbors_invitation.update(neighbors_invitation_params)
        format.html { redirect_to @neighbors_invitation, notice: 'Neighbors invitation was successfully updated.' }
        format.json { render :show, status: :ok, location: @neighbors_invitation }
      else
        format.html { render :edit }
        format.json { render json: @neighbors_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /neighbors_invitations/1
  # DELETE /neighbors_invitations/1.json
  def destroy
    @neighbors_invitation.destroy
    respond_to do |format|
      format.html { redirect_to neighbors_invitations_url, notice: 'Neighbors invitation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_neighbors_invitation
      @neighbors_invitation = NeighborsInvitation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def neighbors_invitation_params
      params.require(:neighbors_invitation).permit(:family_id, :neighbor_id, :status, :user_id, :initial_text, :respond_by_id, :response_text, :respond_at)
    end
end
