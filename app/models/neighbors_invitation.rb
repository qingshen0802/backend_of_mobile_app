class NeighborsInvitation < ActiveRecord::Base
  module Statuses
  	NEW = 'new'
  	ACCEPTED = 'accepted'
  	CANCELED = 'canceled'
    REJECTED = 'rejected'
  end
  belongs_to :family
  belongs_to :invited_family, class_name: 'Family'
  belongs_to :user
  belongs_to :respond_by, class_name: 'User'
  has_many :neighbors_families_links

  validates :invitation_text, presence: true
  validates :invited_at, presence: true

  after_save :update_neighbors_families_links
  after_create :send_neighbors_invitation_messages

  scope :pending, -> {where(status: Statuses::NEW)}
  scope :rejected, -> {where(status: Statuses::REJECTED)}
  scope :accepted, -> {where(status: Statuses::ACCEPTED)}
  scope :cancelled, -> {where(status: Statuses::CANCELED)}

  def accepted?
  	status == Statuses::ACCEPTED
  end

  def update_neighbors_families_links
    neighbors_families_links.destroy
    if accepted?
      neighbors_families_links.create!(family: family, neighbor_family: invited_family, initiator: true)
      neighbors_families_links.create!(family: invited_family, neighbor_family: family, initiator: false)
    end
  end

  def send_neighbors_invitation_messages
    sender_app = user.app
    family.supervisors.each do |supervisor|
      Info.create_initiated_neighbors_invitation_message(self, supervisor)
    end
    invited_family.parents.each do |parent|
      Info.create_invited_neighbors_invitation_message(self, parent)
    end
  end
end
