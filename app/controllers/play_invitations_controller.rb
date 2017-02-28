class PlayInvitationsController < ApplicationController
  before_action :set_play_invitation, only: [:show, :edit, :update, :destroy, :accept, :reject]
  before_action :get_children_and_friends, only: [:new, :create]
  before_action :get_params, only: [:index]

  # GET /play_invitations
  # GET /play_invitations.json
  def index
    @play_invitations = PlayInvitation.active.order('id DESC').paginate(:page => @page,:per_page => @per_page)
  end

  # GET /play_invitations/1
  # GET /play_invitations/1.json
  def show
  end

  # GET /play_invitations/new
  def new
    @play_invitation = PlayInvitation.new
  end

  # GET /play_invitations/1/edit
  def edit
  end

  def accept
    @play_invitation.accept_by_admin
    EventLog.acceptPlayInvitation current_user, @play_invitation
    respond_to do |format|
      format.html { redirect_to play_invitations_url, notice: 'Play invitation was successfully accepted.' }
      format.json { render :json, {code: 200} }
    end
  end

  def reject
    @play_invitation.reject_by_admin
    EventLog.rejectPlayInvitation current_user, @play_invitation
    respond_to do |format|
      format.html { redirect_to play_invitations_url, notice: 'Play invitation was successfully rejected.' }
      format.json { render :json, {code: 200} }
    end
  end

  # POST /play_invitations
  # POST /play_invitations.json
  def create
    @play_invitation = PlayInvitation.new(play_invitation_params)
    @play_invitation.invited_at = Time.now

    respond_to do |format|
      if @play_invitation.save
        EventLog.createPlayInvitation current_user, @play_invitation
        format.html { redirect_to play_invitations_url, notice: 'Play invitation was successfully created.' }
        format.json { render :show, status: :created, location: @play_invitation }
      else
        format.html { render :new }
        format.json { render json: @play_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /play_invitations/1
  # PATCH/PUT /play_invitations/1.json
  def update
    respond_to do |format|
      if @play_invitation.update(play_invitation_params)
        format.html { redirect_to play_invitations_url, notice: 'Play invitation was successfully updated.' }
        format.json { render :show, status: :ok, location: @play_invitation }
      else
        format.html { render :edit }
        format.json { render json: @play_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /play_invitations/1
  # DELETE /play_invitations/1.json
  def destroy
    @play_invitation.remove! if current_user.admin?
    respond_to do |format|
      format.html { redirect_to play_invitations_url, notice: "Play invitation was#{"n't" unless current_user.admin?} successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def get_params
      @type = params[:type]
      @page = params[:page]
      @per_page = params[:per_page]
      if @per_page.blank?
        @per_page = @timestamp ? 10000 : 10
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_play_invitation
      @play_invitation = PlayInvitation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def play_invitation_params
      params.require(:play_invitation).permit(:child_id, :invited_child_id, :parent_id, :duration)
    end

    def get_children_and_friends
      if current_user.parent?
        @family = current_user.family
        @families = [@family]
        @parents = {@family.id => [current_user.supervisor]}
        @friends = current_user.children.inject({}){|memo, c| memo.merge(c.id => c.friends)}
      elsif current_user.admin?
        @families = Family.all
        @friends = Child.all.inject({}){|memo, c| memo.merge(c.id => c.friends)}
        @parents = @families.inject({}){|memo, f| memo.merge(f.id => f.parents)}
        @family = nil
      else
        @friends = {}
        @parents = []
        @families = []
      end
      @children = @families.inject({}){|memo, f| memo.merge(f.id => f.children)}
    end
end
