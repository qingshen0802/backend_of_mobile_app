class AddRecipientPlayceletIdToInfos < ActiveRecord::Migration
  def change
  	add_column :infos, :recipient_playcelet_id, :integer, :null => true
  end
end
