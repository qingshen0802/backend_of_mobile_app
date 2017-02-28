class AddNotifiedAtToPlayInvitations < ActiveRecord::Migration
  def change
  	add_column :play_invitations, :notified_at, :datetime, null: true
  end
end
