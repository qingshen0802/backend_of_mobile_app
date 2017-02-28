json.array!(@supervisors) do |supervisor|
  json.extract! supervisor, :id, :first_name, :last_name, :family_id, :application_id, :user_id
  json.url supervisor_url(supervisor, format: :json)
end
