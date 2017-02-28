require 'calculate_user_details_actions'

class Api::V1::StatusController < Api::BaseController
  include CalculateUserDetailsActions

  protect_from_forgery with: :null_session

  respond_to :json
  before_action :calculate_user_details, only: [:index]

  # GET /sessions.json
  def index
    if user_signed_in?
      EventLog.getStatus current_user, json_user_details
      render json: { code: "200", :user => current_user, app: current_user.app}.merge(json_user_details), status: 200
    else
      render json: { code: "200", info: "You are logged out", :user => current_user}, status: 200 
    end
  end

end
