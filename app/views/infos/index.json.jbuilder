json.array!(@infos) do |info|
  json.extract! info, :id, :message_type, :timestamp, :received_at, :app_id, :child_id, :recipient_child_id, :sender_app_id
  json.url info_url(info, format: :json)
end
