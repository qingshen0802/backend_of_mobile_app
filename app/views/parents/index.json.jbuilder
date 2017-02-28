json.array!(@parents) do |parent|
  json.extract! parent, :id, :first_name, :last_name, :family_id, :application_id, :user_id
  json.url parent_url(parent, format: :json)
end
