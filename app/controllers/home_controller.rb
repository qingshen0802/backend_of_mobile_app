class HomeController < ApplicationController
  before_action :calculate_user_details
  
  def index
  end

  def delete_all_messages_data
    PlayceletDataCleaner.clear_all if current_user.admin?
  	redirect_to root_path
  end
end
