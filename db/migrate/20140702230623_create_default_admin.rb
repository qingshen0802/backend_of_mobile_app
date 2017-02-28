class CreateDefaultAdmin < ActiveRecord::Migration
  def change
  	User.create({
  		name: 'admin',
  		email: 'admin@playcelet.com',
  		password: 'password',
  		password_confirmation: 'password',
  		role: :admin,
  	})
  end
end
