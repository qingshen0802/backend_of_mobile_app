class AddDisplayTypeToInfos < ActiveRecord::Migration
  def change
  	add_column :infos, :display_type, :string
  	add_index :infos, :display_type
  end
end
