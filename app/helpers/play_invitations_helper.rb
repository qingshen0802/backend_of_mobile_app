module PlayInvitationsHelper
  def select_play_invitation_duration_tag(form, object, options={})
    select :play_invitation, :duration,
      options_for_select(PlayInvitation::EndTimePeriods.all.map{|period| [period.first, period.last]}, selected: nil),
      options.merge(onclick: 'window.PlayInvitation.displayEndTime(this)', include_blank: '-- Select End Time --')
  end

  def select_play_invitation_family_tag(form, object, options={})
  	select_tag :family_id,
  	  options_for_select(@families.map{|family| [family.name, family.id]}, selected: (@family_id || object.family_id)),
  	  options.merge(onclick: 'window.PlayInvitation.showChildren(this)', include_blank: '-- Select Family --')
  end

  def select_play_invitation_parent_tag(parents, options={})
    select :play_invitation, options[:name] || :parent_id, options_for_select(parents.map{|parent| [parent.name, parent.id]}), options.merge(include_blank: '-- Select Sender Parent --')
  end

  def select_play_invitation_child_tag(children, options={})
    select :play_invitation, options[:name] || :child_id, colored_children_options_for_select(children), options.merge(include_blank: '-- Select Child --')
  end

  def colored_children_options_for_select(container_collection, options={})
    container_collection.map do |child|
      "<option value=\"#{child.id}\" style=\"background-color: ##{child.color}\" #{'selected=selected' if options[:selected] && (options[:selected] == child.id)}>#{child.name}</option>"
    end.join("\n").html_safe
  end

  def select_play_invitation_invited_child_tag(children, options={})
  	select_play_invitation_child_tag(children, options.merge(name: :invited_child_id))
  end
end
