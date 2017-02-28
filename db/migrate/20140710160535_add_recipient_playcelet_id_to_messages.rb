class AddRecipientPlayceletIdToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :recipient_playcelet_id, :integer, :null => true
  end
end
