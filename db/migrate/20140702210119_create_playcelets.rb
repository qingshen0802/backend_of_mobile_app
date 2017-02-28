class CreatePlaycelets < ActiveRecord::Migration
  def change
    create_table :playcelets do |t|
      t.string :color, :null => false
      t.string :color_name, :null => true
      t.string :playcelet_id, :null => false
      t.references :app, :null => true
      t.datetime :located_at, :null => true

      t.timestamps
    end
    add_index :playcelets, :playcelet_id
    add_index :playcelets, :app_id
  end
end
