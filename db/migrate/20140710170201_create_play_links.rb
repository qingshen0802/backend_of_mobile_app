class CreatePlayLinks < ActiveRecord::Migration
  def change
    create_table :play_links do |t|
      t.references :playcelet, index: true
      t.references :invited_playcelet, references: :playcelets, index: true
      t.references :family, index: true
      t.references :play_invitation, index: true

      t.timestamps
    end
  end
end
