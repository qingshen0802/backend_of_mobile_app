module CalculateUserDetailsActions
  def calculate_supervisor_details
    @place = @supervisor.place
    @located_children = Child.near(@supervisor)
  end

  def calculate_parent_details
    @supervisor = @parent
    @family = @parent.family
    @parents = @family.supervisors
    @children = @family.children
    @located_children = Child.near(@supervisor)
  end

  def calculate_user_details
    u = @user || current_user
    return unless u
    if u.supervisor?
      @supervisor = u.supervisor
      calculate_supervisor_details
    elsif u.parent?
      @parent = u.parent
      calculate_parent_details
    end
  end

  def json_user_details
    u = @user || current_user
    if u.supervisor?
      {
        supervisor: @supervisor.as_json,
        place: @place.as_json,
        located_children: @located_children.map{|c| c.as_json(status:true, parent: true, family: true)},
      }
    elsif u.parent?
      {
        parent: @parent.as_json,
        supervisor: @supervisor.as_json,
        family: @family.as_json,
        parents: @parents.map(&:as_json),
        children: @children.map{|c| c.as_json(supervisor:true, status:true, place: true, family: true)},
        located_children: @located_children.map{|c| c.as_json(status:true, parent: true, family: true)},
      }
    else
      {}
    end.merge({role: u.role})
  end
end