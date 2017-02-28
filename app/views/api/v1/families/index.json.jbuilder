json.array!(@families) do |family|
  json.extract! family, :id, :name, :address
  json.url family_url(family, format: :json)
end
