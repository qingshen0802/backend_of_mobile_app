class AddNameToPlaycelets < ActiveRecord::Migration
  def change
  	add_column :playcelets, :name, :string, null: true
  end
end
