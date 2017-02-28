require 'calculate_user_details_actions'

class Api::V2::SessionsController < Devise::SessionsController
  include CalculateUserDetailsActions

  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/vnd.playcelet.api.v2' }
  before_action :calculate_user_details, only: :create

  def create
    warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    render json: { code: "200", version: 2, user: current_user, app: current_user.app}, status: 200
  end

  def destroy
    warden.authenticate!(scope: resource_name, recall: "#{controller_path}#failure")
    sign_out
    render json: { code: "200", info: "Logged out" }, status: 200
  end

  def failure
    render json: { code: "401", error: "Login Credentials Failed" }, status: 401
  end
end
