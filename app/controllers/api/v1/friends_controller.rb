class Api::V1::FriendsController < Api::BaseController
  protect_from_forgery with: :null_session
  
  before_action :get_params, only: [:index]
  before_action :set_friend, only: [:show, :edit, :update, :destroy]
  respond_to :json

  def index
  	if @child
      EventLog.getFriends(current_user, nil, child1_id: @child.id)
  		render json: { code: "200", friends: @child.friends.map{|c| c.as_json(play_networks: true) } }
  	else
      EventLog.getFriends(current_user)
      render json: { code: "500", error: "child should be set" }, status: 500
  	end
  end

  private

  def get_params
  	@child_id = params[:child_id] || params[:child]
    @play_network_id = params[:play_network_id] || params[:play_network]
  	if @child_id
  	  @child = Child.find(@child_id)
  	end
  end
end
