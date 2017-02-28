class FixStatusNewForExistingPlayInvitations < ActiveRecord::Migration
  def change
  	execute "UPDATE play_invitations SET status='0. new' where status='new'"
  end
end
