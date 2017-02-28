class NeighborsFamiliesLinksController < ApplicationController

  # GET /neighbors_families_links
  # GET /neighbors_families_links.json
  def index
    @neighbors_families_links = NeighborsFamiliesLink.all.paginate(:page => params[:page],:per_page => 10)
  end
end
