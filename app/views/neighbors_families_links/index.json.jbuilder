json.array!(@neighbors_families_links) do |neighbors_families_link|
  json.extract! neighbors_families_link, :id, :family_id, :neighbor_id
  json.url neighbors_families_link_url(neighbors_families_link, format: :json)
end
