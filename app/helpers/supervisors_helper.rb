module SupervisorsHelper
  def select_supervisor_family_tag(form, object)
    form.text_field :family_id
  end

  def select_supervisor_application_tag(form, object)
    form.text_field :app_id
  end

  def select_supervisor_user_tag(form, object)
    form.text_field :user_id
  end
end
