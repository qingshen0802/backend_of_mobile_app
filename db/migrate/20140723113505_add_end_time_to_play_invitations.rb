class AddEndTimeToPlayInvitations < ActiveRecord::Migration
  def change
  	add_column :play_invitations, :end_time, :datetime
  	add_index :play_invitations, :end_time
  end
end
