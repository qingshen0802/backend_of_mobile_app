json.array!(@neighbors_invitations) do |neighbors_invitation|
  json.extract! neighbors_invitation, :id, :family_id, :neighbor_id, :status, :user_id, :initial_text, :respond_by_id, :response_text, :respond_at
  json.url neighbors_invitation_url(neighbors_invitation, format: :json)
end
