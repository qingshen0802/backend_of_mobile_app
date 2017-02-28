class AddDurationToPlayInvitations < ActiveRecord::Migration
  def change
  	add_column :play_invitations, :duration, :integer
  end
end
