require 'calculate_user_details_actions'

class Api::V1::SessionsController < Devise::SessionsController
  include CalculateUserDetailsActions

  skip_before_action :require_no_authentication, only: :create
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/vnd.playcelet.api.v1' }
  before_action :calculate_user_details, only: :create

  def create
    if user_signed_in? && (params[:user][:email] != current_user.email)
      EventLog.signOutAlreadySignedInUser(current_user, params)
      warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
      sign_out
      render json: { code: "401", info: "Sign out previous user. Please try again" }, status: 401
      return
    end
    warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    EventLog.signIn(current_user)
    render json: { code: "200", :user => current_user, app: current_user.app}.merge(json_user_details), status: 200
  end

  def destroy
    EventLog.signOut(current_user)
    warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    sign_out
    render json: { code: "200", info: "Logged out" }, status: 200
  end

  def failure
    render json: { code: "401", error: "Login Credentials Failed" }, status: 401
  end
end
