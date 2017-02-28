class AddPlaceToPlayInvitation < ActiveRecord::Migration
  def change
  	add_column :play_invitations, :place_id, :integer
	execute <<-UPDATE_PLAY_INVITATIONS_SQL
		UPDATE	play_invitations AS pi
		SET		place_id	= c.family_id
		FROM	children AS c
		WHERE	pi.child_id = c.id
	UPDATE_PLAY_INVITATIONS_SQL
  end
end
