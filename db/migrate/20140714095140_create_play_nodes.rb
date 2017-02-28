class CreatePlayNodes < ActiveRecord::Migration
  def change
    create_table :play_nodes do |t|
      t.references :child, index: true
      t.references :play_network, index: true

      t.timestamps
    end
  end
end
