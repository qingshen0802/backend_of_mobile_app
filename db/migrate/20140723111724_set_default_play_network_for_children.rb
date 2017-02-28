class SetDefaultPlayNetworkForChildren < ActiveRecord::Migration
  def change
  	Child.where(default_play_network_id: nil).each do |child|
  		default_play_network = child.play_networks.first
  		if default_play_network
	  		puts "Update \"#{child}\": Set Default Play Network \"#{default_play_network}\""
	  		child.update_attribute(:default_play_network_id, default_play_network.id)
	  	end
  	end
  end
end
