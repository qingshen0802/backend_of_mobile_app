class AddPasswordToParent < ActiveRecord::Migration
  def change
  	add_column :supervisors, :password, :string
  end
end
