json.array!(@messages) do |message|
  json.extract! message, :id, :child_id, :recipient_child_id, :app_id, :message_type
  json.url message_url(message, format: :json)
end
