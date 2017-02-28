class AddNeighborInvitationToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :invitation_id, :integer, :null => true
  	add_column :messages, :family_id, :integer, :null => true
  	add_column :messages, :invited_family_id, :integer, :null => true
  end
end
