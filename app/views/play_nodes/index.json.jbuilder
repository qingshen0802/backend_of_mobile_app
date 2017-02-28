json.array!(@play_nodes) do |play_node|
  json.extract! play_node, :id, :child_id, :play_network_id
  json.url play_node_url(play_node, format: :json)
end
