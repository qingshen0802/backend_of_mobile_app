class CreateSupervisors < ActiveRecord::Migration
  def change
    create_table :supervisors do |t|
      t.string :type, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.references :family, :null => true
      t.references :user, :null => false
      t.references :app, :null => true

      t.timestamps
    end

    add_index :supervisors, :family_id
    add_index :supervisors, :user_id
    add_index :supervisors, :app_id
  end
end
