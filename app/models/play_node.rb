class PlayNode < ActiveRecord::Base
  belongs_to :child
  belongs_to :play_network
  
end
