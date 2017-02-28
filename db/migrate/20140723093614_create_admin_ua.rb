class CreateAdminUa < ActiveRecord::Migration
  def change
  	User.create({
  		name: 'admin_ua',
  		email: 'admin_ua@playcelet.com',
  		password: 'password',
  		password_confirmation: 'password',
  		role: :admin,
  		time_zone: 'Kyiv'
  	})
  end
end
