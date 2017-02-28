class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.string :type, :null => false, :default => 'Family'
      t.string :name, :null => false
      t.string :address

      t.timestamps
    end
  end
end
