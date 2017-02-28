class AddLightModeAndColorToInfos < ActiveRecord::Migration
  def change
  	add_column :infos, :light_mode, :string, null: true
  	add_column :infos, :color, :string, null: true
  end
end
