class AddDefaultPlayNetworkToChildren < ActiveRecord::Migration
  def change
  	add_column :children, :default_play_network_id, :integer
  end
end
