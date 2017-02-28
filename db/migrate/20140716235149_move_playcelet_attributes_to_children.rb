class MovePlayceletAttributesToChildren < ActiveRecord::Migration
	def change
		change_table(:children) do |t|
			t.string	:color,			null: false, default: 'FFFFFF'
			t.string	:color_name
			t.string	:mac_address,	null: false, default: '01:23:45:67:89:ab'
			t.string	:playcelet
			t.integer	:app_id
			t.datetime	:located_at
			t.integer	:last_app_id
		end

		execute <<-UPDATE_CHILDREN_ATTRIBUTES_SQL
			UPDATE children AS c
			SET
				color		= p.color,
				color_name	= p.color_name,
				mac_address	= p.playcelet_id,
				playcelet	= p.name,
				app_id		= p.app_id,
				located_at	= p.located_at,
				last_app_id	= p.last_app_id
			FROM playcelets AS p
			WHERE c.playcelet_id = p.id
		UPDATE_CHILDREN_ATTRIBUTES_SQL
		add_index :children, :app_id
		add_index :children, :mac_address

		change_table :infos do |t|
			t.integer	:child_id
			t.integer	:recipient_child_id
		end
		execute <<-UPDATE_INFOS_CHILD_SQL
			UPDATE infos AS i
			SET child_id = c.id
			FROM children AS c
			WHERE c.playcelet_id = i.playcelet_id
		UPDATE_INFOS_CHILD_SQL
		execute <<-UPDATE_INFOS_RECIPIENT_CHILD_SQL
			UPDATE infos AS i
			SET recipient_child_id = c.id
			FROM children AS c
			WHERE c.playcelet_id = i.recipient_playcelet_id
		UPDATE_INFOS_RECIPIENT_CHILD_SQL
		add_index :infos, [:recipient_child_id, :status]
		add_index :infos, :recipient_child_id
		remove_column :infos, :playcelet_id
		remove_column :infos, :recipient_playcelet_id

		change_table :messages do |t|
			t.integer	:child_id
			t.integer	:recipient_child_id
		end
		execute <<-UPDATE_MESSAGES_CHILD_SQL
			UPDATE messages AS m
			SET child_id = c.id
			FROM children AS c
			WHERE c.playcelet_id = m.playcelet_id
		UPDATE_MESSAGES_CHILD_SQL
		execute <<-UPDATE_MESSAGES_RECIPIENT_CHILD_SQL
			UPDATE messages AS m
			SET recipient_child_id = c.id
			FROM children AS c
			WHERE c.playcelet_id = m.recipient_playcelet_id
		UPDATE_MESSAGES_RECIPIENT_CHILD_SQL
		add_index :messages, [:recipient_child_id, :status]
		add_index :messages, :recipient_child_id
		remove_column :messages, :playcelet_id
		remove_column :messages, :recipient_playcelet_id

		change_table :play_invitations do |t|
			t.integer	:child_id
			t.integer	:invited_child_id
		end
		execute <<-UPDATE_PLAY_INVITATION_CHILD_SQL
			UPDATE play_invitations AS pi
			SET child_id = c.id
			FROM children AS c
			WHERE c.playcelet_id = pi.playcelet_id
		UPDATE_PLAY_INVITATION_CHILD_SQL
		execute <<-UPDATE_PLAY_INVITATION_INVITED_CHILD_SQL
			UPDATE play_invitations AS pi
			SET invited_child_id = c.id
			FROM children AS c
			WHERE c.playcelet_id = pi.invited_playcelet_id
		UPDATE_PLAY_INVITATION_INVITED_CHILD_SQL
		add_index :play_invitations, [:invited_child_id, :status]
		add_index :play_invitations, :invited_child_id
		remove_column :play_invitations, :playcelet_id
		remove_column :play_invitations, :invited_playcelet_id

		drop_table :play_links
		drop_table :playcelets
	end
end
