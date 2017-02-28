class CreateAdminDk < ActiveRecord::Migration
  def change
  	User.create({
  		name: 'admin_dk',
  		email: 'admin_dk@playcelet.com',
  		password: 'password',
  		password_confirmation: 'password',
  		role: :admin,
  		time_zone: 'Copenhagen'
  	})
  end
end
