json.array!(@children) do |child|
  json.extract! child, :id, :first_name, :last_name, :family_id, :mac_address, :playcelet, :color, :color_name
  json.url child_url(child, format: :json)
end
