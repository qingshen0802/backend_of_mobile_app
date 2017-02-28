class CreateNeighborsFamiliesLinks < ActiveRecord::Migration
  def change
    create_table :neighbors_families_links do |t|
      t.references :family, null: false, index: true
      t.references :neighbor_family, references: :families, null: false, index: true
      t.references :neighbors_invitation, null: false, index: true
      t.boolean    :initiator, null: false, index: true

      t.timestamps
    end
  end
end
