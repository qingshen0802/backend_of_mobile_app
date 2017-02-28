class AddInvitationTypeToInfos < ActiveRecord::Migration
  def change
  	add_column :infos, :invitation_type, :string, :null => true
  	execute "UPDATE infos SET invitation_type='NeighborsInvitation' WHERE invitation_id IS NOT NULL"
  end
end
