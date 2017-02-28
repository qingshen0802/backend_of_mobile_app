module ParentsHelper
  def select_parent_family_tag(form, object, options={})
  	form.select :family_id, options_for_select(@families.map{|family| [family.name, family.id]}, selected: object.family_id), options.merge(include_blank: '-- Select Family --')
  end
end
