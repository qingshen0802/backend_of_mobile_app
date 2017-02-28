class AddInvitationTypeToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :invitation_type, :string, :null => true
  	execute "UPDATE messages SET invitation_type='NeighborsInvitation' WHERE invitation_id IS NOT NULL"
  end
end
