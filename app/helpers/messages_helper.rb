module MessagesHelper
  def select_message_type_tag(form, object, options={})
  	form.select :message_type, options_for_select(Message::MessageTypes::LIST, selected: object.message_type), options.merge(include_blank: '-- Select Message Type --')
  end

  def show_message_text_tag(message)
  	content_tag(:span, (message.message_text ? message.message_text[0..30] : ''), id: "short_message_text_#{message.id}", style: 'cursor:pointer', onclick: "$('#short_message_text_#{message.id}').hide(); $('#full_message_text_#{message.id}').show(); return false;") + \
  		content_tag(:span, message.message_text, id: "full_message_text_#{message.id}", style: 'cursor:pointer; display:none;', onclick: "$('#full_message_text_#{message.id}').hide(); $('#short_message_text_#{message.id}').show(); return false;")
  end

  def select_message_child_tag(children, options={})
    select_tag options[:name] || 'message[child_id]', colored_children_options_for_select(children, selected: options[:selected]), options.merge(include_blank: '-- Select Child --')
  end

  def select_message_parent_tag(parents, options={})
    select_tag options[:name] || 'message[parent_id]', options_for_select(parents.map{|parent| [parent.name, parent.id]}, selected: options[:selected]), options.merge(include_blank: '-- Select Parent --')
  end

end
