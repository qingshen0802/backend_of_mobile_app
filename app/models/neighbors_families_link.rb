class NeighborsFamiliesLink < ActiveRecord::Base
  belongs_to :family
  belongs_to :neighbor_family, class_name: 'Family'
  belongs_to :neighbors_invitation
end
