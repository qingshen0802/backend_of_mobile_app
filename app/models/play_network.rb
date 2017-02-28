class PlayNetwork < ActiveRecord::Base
  has_many :play_nodes
  has_many :children, through: :play_nodes
  validates :name, presence: true

  def to_s
    name
  end

  def as_json(options = {})
    result = {
      id: id,
      name: name,
    }
    result
  end
end
