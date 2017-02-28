class CreatePlayNetworks < ActiveRecord::Migration
  def change
    create_table :play_networks do |t|
      t.string :name

      t.timestamps
    end
  end
end
