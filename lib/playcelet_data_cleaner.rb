class PlayceletDataCleaner
	PLAYCELET_DATA_CLASSES = [
		EventLog,
		DelayedJob,
		PlayInvitation,
		Info,
		Message
	]
	class << self
		def clear_all
			PLAYCELET_DATA_CLASSES.each do |playcelet_data_class|
				playcelet_data_class.destroy_all
			end
			Child.all.update_all(app_id: nil)
		end

		def clear3DaysData
			records_age_options = ['created_at <= ?', 3.days.ago.utc]
			PLAYCELET_DATA_CLASSES.each do |playcelet_data_class|
				playcelet_data_class.destroy_all(records_age_options)
			end
			EventLog.clear3DaysData
		end
	end
end