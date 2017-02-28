class App < ActiveRecord::Base
  has_one :supervisor
  has_many :messages
  has_many :infos
  has_many :children

  validates :name, presence: true
  validates :version, presence: true
  class << self
  	def create_android_app
  	  App.create(name: "Playcelet Phone#{App.count}", version: 'Android')
  	end
  end

  def as_json(options = {})
    {
      id: id,
      name: name,
      version: version,
    }
  end
end
