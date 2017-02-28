class Family < ActiveRecord::Base
  has_many :children
  has_many :supervisors
  has_many :users, through: :supervisors

  # Neighbors
  has_many :neighbors_invitations
  has_many :invited_families, through: :neighbors_invitations

  has_many :play_invitations, foreign_key: :place_id

  has_many :neighbors_families_links
  has_many :neighbor_families, through: :neighbors_families_links

  validates :name, presence: true

  scope :families, -> { where(type: 'Family') }
  scope :places, -> { where(type: 'Place') }

  def can_be_destroyed?
    parents.blank? && children.blank?
  end

  def play_networks
    children.map{ |c| c.play_networks }.flatten.uniq.sort{|a,b| a.name <=> b.name}
  end

  def parents
  	supervisors
  end

  def to_s
    name
  end

  def as_json(options = {})
    result = {
      id: id,
      name: name,
      address: address,
    }
    result.merge!(parents: parents.map(&:as_json)) if options[:parents]
    result.merge!(children: children.map(&:as_json)) if options[:children]
    result
  end
end
