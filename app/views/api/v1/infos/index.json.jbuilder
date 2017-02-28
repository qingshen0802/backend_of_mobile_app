json.array!(@infos) do |info|
  json.extract! info, :id, :message_type, :display_type, :message_text, :timestamp, :received_at, :supervisor, :app, :child, :family, :sender_app, :sender_supervisor, :invited_child, :color, :light_mode, :invitation_id
  json.url api_info_url(info, format: :json)
end
