require 'playcelet_colors'
colors = PlayceletColors::NAME_AND_CODES_LIST

index = ''
# Steen Voersaa
  puts "Voersaa family #{index}"
	fvoersaa = Family.create!(name: "Voersaa", address: "1st Example street")
color_index = 0
	steen_voersaa_user = User.create!({name: "steen_voersaa", email: "steen_voersaa@playcelet.com", password: "password", password_confirmation: "password", role: :parent })
	steen_voersaa = Parent.create!(:type => 'Parent',first_name: "Steen", last_name: fvoersaa.name, family: fvoersaa, user: steen_voersaa_user)

	baby_voersaa = Child.create!({first_name: "Baby", last_name: fvoersaa.name, family: fvoersaa, playcelet: 'Playcelet BLE 4', playcelet_id: "00:07:80:68:16:CD"}.merge(colors[1]))
	boy_voersaa = Child.create!({first_name: "Boy", last_name: fvoersaa.name, family: fvoersaa, playcelet: 'Playcelet BLE 4', playcelet_id: "00:07:80:68:03:E5"}.merge(colors[2]))

# Miles
  puts "Miles family #{index}"
	fmiles = Family.create!(name: "Miles#{index}", address: "3rd, Example #{index} street")
	mike_miles_user = User.create!({name: "mike_miles#{index}", email: "mike_miles#{index}@playcelet.com", password: "password", password_confirmation: "password", role: :parent })
	mike_miles = Parent.create!(:type => 'Parent',first_name: "Mike", last_name: fmiles.name, family: fmiles, user: mike_miles_user)

	baby_miles = Child.create!({first_name: "Baby", last_name: fmiles.name, family: fmiles, playcelet: 'Playcelets BLE 7', mac_address: '00:07:80:68:05:65'}.merge(colors[3]))
	Message.create_play_invitation_message(baby_miles, baby_miles, "Hi John and Jane. I'd like to invite Baby Roe come to play with Baby Miles. Mike", mike_miles.app)

	[120, 115, 110, 105, 100, 95, 90, 85, 80, 75, 70, 65, 60, 55, 50, 45, 40].each do |time_john|
		Message.send_check_in( boy_voersaa, steen_voersaa.app, time_john.minutes.ago)
	end
	Message.send_check_out(boy_voersaa, steen_voersaa.app, 36.minutes.ago)
	[40, 35, 30, 25, 20, 15, 10, 5, 0].each do |time_jane|
		Message.send_check_in( boy_voersaa, steen_voersaa.app, time_jane.minutes.ago)
	end

	[120, 115, 110, 105, 100, 95, 90, 85, 80, 75, 70, 65, 60].each do |time_john|
		Message.send_check_in( baby_voersaa, steen_voersaa.app, time_john.minutes.ago)
	end
	Message.send_check_out(baby_voersaa, steen_voersaa.app, 56.minutes.ago)
	[40, 35, 30, 25, 20, 15, 10, 5, 0].each do |time_mike|
		Message.send_check_in( baby_voersaa, steen_voersaa.app, time_mike.minutes.ago)
	end

	[120, 115, 110, 105, 100, 95, 90, 85, 80, 75, 70, 65, 60, 55, 50, 45, 40, 35, 30, 25, 20, 15, 10, 5, 0].each do |time_mike|
		Message.send_check_in( baby_miles, mike_miles.app, time_mike.minutes.ago)
	end
	ftest = Family.create!(name: "Test#{index}", address: "0st Example#{index} street")

	sam_test_user = User.create!({name: "sam_test#{index}", email: "sam_test#{index}@playcelet.com", password: "password", password_confirmation: "password", role: :parent })
	sam_test = Parent.create!(:type => 'Parent',first_name: "Sam", last_name: ftest.name, family: ftest, user: sam_test_user)
	simona_test_user = User.create!({name: "simona_test#{index}", email: "simona_test#{index}@playcelet.com", password: "password", password_confirmation: "password", role: :parent })
	simona_test = Parent.create!(:type => 'Parent',first_name: "Simona", last_name: ftest.name, family: ftest, user: simona_test_user)

	real_test = Child.create!({first_name: "Real", last_name: ftest.name, family: ftest, playcelet: 'Playcelet BLE 6', playcelet_id: "00:07:80:68:16:B5"}.merge(colors[4]))
	fake_test = Child.create!({first_name: "Fake", last_name: ftest.name, family: ftest, playcelet: 'Playcelet BLE -1', playcelet_id: "00:07:80:68:16:00"}.merge(colors[5]))

	Message.create_play_invitation_message(baby_miles, real_test, "Hi Sam and Simone. I'd like to invite Real Test come to play with Baby Miles. Mike", mike_miles.app)
	Message.create_play_invitation_message(baby_miles, fake_test, nil, mike_miles.app)

	Message.create_play_invitation_message(real_test, boy_voersaa, "Hi Steen. I'd like to invite Boy Doe come to play with Real Test. Sam Test", sam_test.app)
