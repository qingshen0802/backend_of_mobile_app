json.array!(@play_invitations) do |play_invitation|
  json.extract! play_invitation, :id, :child_id, :invited_child_id, :app_id, :invited_at, :invitation_text, :respond_by_id, :response_text, :respond_at, :status
  json.url play_invitation_url(play_invitation, format: :json)
end
