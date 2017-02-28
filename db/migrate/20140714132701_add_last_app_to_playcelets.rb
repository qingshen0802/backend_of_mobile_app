class AddLastAppToPlaycelets < ActiveRecord::Migration
  def change
  	add_column :playcelets, :last_app_id, :integer, null: true
  	add_index :playcelets, :last_app_id
  end
end
