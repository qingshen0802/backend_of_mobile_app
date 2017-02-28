class AddProposedEndTimeProposedDurationToPlayInvitations < ActiveRecord::Migration
  def change
  	add_column  :play_invitations, :proposed_duration, :integer
    add_column  :play_invitations, :proposed_end_time, :datetime
  end
end
