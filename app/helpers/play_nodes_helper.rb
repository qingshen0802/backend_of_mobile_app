module PlayNodesHelper
  def select_play_node_play_network_tag(form, object, options={})
  	form.select :play_network_id, options_for_select(@play_networks.map{|play_network| [play_network.name, play_network.id]}, selected: object.play_network_id), options.merge(include_blank: '-- Select Play Network --')
  end

  def select_play_node_child_tag(form, object, options={})
  	form.select :child_id, options_for_select(@children.map{|child| [child.name, child.id]}, selected: object.child_id), options.merge(include_blank: '-- Select Child --')
  end
end
