class RemoveDefaultStatusForPlayInvitationsStatus < ActiveRecord::Migration
  def change
  	change_column_default :play_invitations, :status, nil
  end
end
