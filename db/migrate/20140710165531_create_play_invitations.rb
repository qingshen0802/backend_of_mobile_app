class CreatePlayInvitations < ActiveRecord::Migration
  def change
    create_table :play_invitations do |t|
      t.references :app, index: true
      t.references :playcelet, index: true
      t.references :invited_playcelet, references: :playcelets, index: true
      t.string :invitation_text
      t.datetime :invited_at
      t.string :status, null: false, default: 'new'
      t.references :respond_by, references: :apps, index: true
      t.string :response_text
      t.datetime :respond_at

      t.timestamps
    end
  end
end
