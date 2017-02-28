class ChangeUserRoleDefault < ActiveRecord::Migration
  def change
  	change_column_default(:users, :role, 'parent')
  	execute "UPDATE users SET role='parent' WHERE role='supervisor'"
  end
end
