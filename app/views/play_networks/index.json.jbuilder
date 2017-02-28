json.array!(@play_networks) do |play_network|
  json.extract! play_network, :id, :name
  json.url play_network_url(play_network, format: :json)
end
