class NeighborsFamiliesController < ApplicationController
  def index
  	if current_user.supervisor_or_parent?
  	  @family = current_user.supervisor.family
  	  @neighbors_families = @family.neighbor_families
  	  @invited_families = @family.invited_families
  	end
  end
end
