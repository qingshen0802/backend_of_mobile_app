class CreateChildren < ActiveRecord::Migration
  def change
    create_table :children do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.references :family, :null => false
      t.references :playcelet, :null => true

      t.timestamps
    end

    add_index :children, :family_id
    add_index :children, :playcelet_id
  end
end
