class Api::V1::PlayInvitationsController < Api::BaseController
  protect_from_forgery with: :null_session
  
  respond_to :json

  before_action :set_play_invitation, only: [:accept, :decline, :cancel]
  before_action :get_params, only: [:index, :last]

  def index
    EventLog.getPlayInvitations(current_user)
  	if current_user.parent?
  	  my_children_ids = current_user.supervisor.family.children.map(&:id)
  	  @play_invitations = PlayInvitation.active.income_and_outcome_by_children(my_children_ids).paginate(:page => @page,:per_page => @per_page)
      render json: @play_invitations.map(&:as_json).map{|p| p.merge(invited: my_children_ids.include?(p[:invited_child][:id]))}, status: 200
  	elsif current_user.admin?
  	  @play_invitations = PlayInvitation.active.paginate(:page => @page,:per_page => @per_page)
      render json: @play_invitations.map(&:as_json), status: 200
  	else
  	  @play_invitations = []
  	end
  end

  def last
    if current_user.parent?
      my_children_ids = current_user.supervisor.family.children.map(&:id)
      @play_invitations = PlayInvitation.active.income_and_outcome_by_children(my_children_ids).paginate(:page => @page,:per_page => @per_page)
      render json: @play_invitations.map(&:as_json).map{|p| p.merge(invited: my_children_ids.include?(p[:invited_child][:id]))}, status: 200
    elsif current_user.admin?
      @play_invitations = PlayInvitation.active.paginate(:page => @page,:per_page => @per_page)
      render json: @play_invitations.map(&:as_json), status: 200
    else
      @play_invitations = []
    end
    EventLog.getLastPlayInvitation(current_user, @play_invitations.blank? ? nil : @play_invitations.first)
  end

  def accept
    if params[:duration]
      @new_duration = params[:duration].to_i
    elsif params[:end_time]
      params[:end_time].is_a?(Integer)
      @new_end_time = params[:end_time].blank? ? nil : Time.at(params[:end_time].to_i)
    else
      @new_duration = 240
    end
    if @play_invitation.accept(current_user.supervisor, @new_end_time, @new_duration)
      EventLog.acceptPlayInvitation current_user, @play_invitation, params
      render json: { code: "200", :play_invitation => @play_invitation.as_json()}, status: 200
    else
      render json: { code: "302", errors: @play_invitation.errors.full_messages }, status: 302
    end
  end

  def cancel
    if @play_invitation.cancel(current_user.supervisor)
      EventLog.cancelPlayInvitation current_user, @play_invitation, params
      render json: { code: "200", :play_invitation => @play_invitation.as_json()}, status: 200
    else
      render json: { code: "302", errors: @play_invitation.errors.full_messages }, status: 302
    end
  end

  def decline
    if @play_invitation.decline(current_user.supervisor)
      EventLog.rejectPlayInvitation current_user, @play_invitation, params
      render json: { code: "200", :play_invitation => @play_invitation.as_json()}, status: 200
    else
      render json: { code: "302", errors: @play_invitation.errors.full_messages }, status: 302
    end
  end

  private
    def set_play_invitation
      @play_invitation = PlayInvitation.find(params[:id])
    end

    def get_params
      @page = params[:page]
      @per_page = params[:per_page]
      if @per_page.blank?
        @per_page = @timestamp ? 10000 : 10
      end
    end

end
