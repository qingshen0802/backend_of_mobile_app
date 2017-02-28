class CreateNeighborsInvitations < ActiveRecord::Migration
  def change
    create_table :neighbors_invitations do |t|
      t.references :family, null: false, index: true
      t.references :invited_family, references: :families, null: false, index: true
      t.string :status, null: false, default: 'new'
      t.references :user, null: false, index: true
      t.string :invitation_text, null: false
      t.datetime :invited_at, null: false
      t.references :respond_by, references: :users, null: true, index: true
      t.string :response_text, null: true
      t.datetime :respond_at, null: true

      t.timestamps
    end
  end
end
