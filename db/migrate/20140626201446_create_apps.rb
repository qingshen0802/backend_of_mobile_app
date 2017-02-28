class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name, :null => false
      t.string :version, :null => false

      t.timestamps
    end
  end
end
