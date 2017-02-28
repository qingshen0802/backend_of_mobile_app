module ChildrenHelper
  def select_child_default_play_network_tag(form, object, options={})
    form.select :default_play_network_id, options_for_select(@play_networks.map{|play_network| [play_network.name, play_network.id]}, selected: object.default_play_network_id), options.merge(include_blank: '-- Select Default Play Network --')
  end

  def select_child_family_tag(form, object, options={})
  	form.select :family_id, options_for_select(@families.map{|family| [family.name, family.id]}, selected: object.family_id), options.merge(include_blank: '-- Select Family --')
  end

  def select_playcelet_color_tag(form, object, options={})
    form.select :color, colored_options_for_select(Child::PlayceletColors::NAME_AND_CODES_LIST.map{|c| [c[:color_name], c[:color]]}, selected: object.color), options.merge(include_blank: '-- Select Color --')
  end

  def colored_options_for_select(container_collection, options)
    container_collection.map do |color|
      "<option value=\"#{color.last}\" style=\"background-color: ##{color.last}\" #{'selected=selected' if options[:selected] && (options[:selected] == color.last)}>#{color.first}</option>"
    end.join("\n").html_safe
  end
end
