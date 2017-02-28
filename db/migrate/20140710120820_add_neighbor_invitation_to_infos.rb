class AddNeighborInvitationToInfos < ActiveRecord::Migration
  def change
  	add_column :infos, :invitation_id, :integer, :null => true
  	add_column :infos, :family_id, :integer, :null => true
  	add_column :infos, :invited_family_id, :integer, :null => true
  end
end
