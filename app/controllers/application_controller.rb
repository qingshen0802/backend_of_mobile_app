require 'calculate_user_details_actions'

class ApplicationController < ActionController::Base
  include CalculateUserDetailsActions
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  
  # change the default link renderer for will_paginate
  def will_paginate(collection_or_options = nil, options = {})

    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end

    # Automatically specify the bootstrap renderer
    # Unless the user wants a different renderer.
    unless options[:renderer]
      options = options.merge :renderer => BootstrapPagination::Rails
    end

    # Automatically set the per_page setting to 10
    unless options[:per_page]
      options = options.merge :per_page => 10
    end

    # Call the original implementation
    super *[collection_or_options, options].compact
  end
end
