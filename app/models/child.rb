require 'playcelet_colors'
require 'playcelet_lighting_modes'

class Child < ActiveRecord::Base
  TIME_FOR_AUTO_CHECKOUT = 5.minutes
  TIME_FOR_FOREIGN_CHECK_IF_PLAYCELET_CHECKED_IN = 2.minutes

  include PlayceletColors

  belongs_to :family
  has_many :supervisors, through: :family
  delegate :parents, to: :family, allow_nil: false
  belongs_to :app
  belongs_to :last_app, class_name: 'App'
  delegate :supervisor, to: :app, allow_nil: true
  delegate :place, to: :supervisor, allow_nil: true

  has_many :messages
  has_many :infos

  has_many :play_nodes
  has_many :play_networks, through: :play_nodes
  belongs_to :default_play_network, class_name: 'PlayNetwork'
  has_many :play_invitations, foreign_key: :invited_child_id

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :family, presence: true
  validates :playcelet, presence: true
  validates :mac_address, presence: true, uniqueness: true
  validates :color, presence: true, inclusion: { :in => PlayceletColors.codes }

  attr_accessor :list_play_networks

  scope :near, ->(s) {s_app = s.is_a?(Supervisor) ? s.app : s.is_a?(App) ? s : nil; s_app.nil? ? {} : where(app: s_app)}

  before_validation :convert_mac_address_to_uppercase
  before_validation :prepare_color_name

  class << self
    def by_app_id(app_id)
      if app_id
        Child.where(app_id: app_id)
      else
        Child.where({})
      end
    end

    def located
      Child.where.not(app_id: nil)
    end
  end
  
  def parents
    supervisors
  end

  def name
  	[first_name, last_name].join(' ')
  end

  def friends
    result_hash = {}
    self.play_networks.all.each do |play_network|
      play_network.play_nodes.all.to_a.reject{|p| p.child_id == self.id}.each do |play_node|
        unless result_hash[play_node.child_id]
          result_hash[play_node.child_id] = play_node.child
          result_hash[play_node.child_id].list_play_networks = []
        end
        result_hash[play_node.child_id].list_play_networks << play_node.play_network
      end
    end
    result_hash.values
  end

  def check_in(new_app, _located_at=nil)
    _located_at ||= Time.now
    new_app_id = new_app.is_a?(App) ? new_app.id : new_app
    if self.located_at.nil? || (self.located_at <= _located_at)
      EventLog.childCheckIn(self, new_app.supervisor)
      check_is_here(new_app)
      update_attributes!(app_id: new_app_id, located_at: _located_at)
      check_come_event
      unless self.family == new_app.supervisor.family
        foreign_check_if_playcelet_checked_in(new_app, Time.now.utc)
      else
        auto_check_out
      end
    end
  end

  def check_is_here(new_app)
    if app.nil? && (last_app == new_app) && (located_at <= TIME_FOR_FOREIGN_CHECK_IF_PLAYCELET_CHECKED_IN.ago)
      Info.child_is_here(self, new_app)
    end
  end

  def check_come_event
    play_invitations.accepted_or_after.before_come.each do |pi|
      if pi.child.family.id == app.supervisor.place.id
        pi.come(app.supervisor)
      end
    end
    play_invitations.ended_or_due_home_or_overdue_home.each do |pi|
      if pi.invited_child.family.id == app.supervisor.place.id
        pi.complete!(app.supervisor)
      end
    end
  end
  handle_asynchronously :check_come_event

  def auto_check_out
    if located_at < TIME_FOR_AUTO_CHECKOUT.ago
      check_out(self.app, nil, auto: true)
    end
  end
  # 5.minutes.from_now will be evaluated when auto_check_out is called
  handle_asynchronously :auto_check_out, :run_at => Proc.new { TIME_FOR_AUTO_CHECKOUT.from_now }

  def foreign_check_if_playcelet_checked_in(_app, _located_at)
    if self.app.nil? || (_located_at >= self.located_at)
      Info.child_is_out_of_contact(self, _app)
      EventLog.childCheckOut(self, _app.supervisor, nil, {})
      update_attributes!(app_id: nil, last_app_id: _app.id)
    end
  end
  handle_asynchronously :foreign_check_if_playcelet_checked_in, :run_at => Proc.new { TIME_FOR_FOREIGN_CHECK_IF_PLAYCELET_CHECKED_IN.from_now }

  def check_out(_app, _located_at=nil, options={})
    _located_at ||= Time.now
    if self.app == _app
      EventLog.childCheckOut(self, _app.supervisor, nil, options)
      update_attributes!(app_id: nil, last_app_id: self.app.id)
      Info.child_is_out_of_contact(self, _app) if self.play_invitations.accepted_or_after.active.blank? && (_app.supervisor.family == self.family)
    end
  end

  def located?
    app_id.present?
  end

  def located_at_timestamp
    located_at.nil? ? nil : Time.at(located_at)
  end

  def to_s
    name
  end

  def as_json(options = {})
    result = {
      id: id,
      name: name,
      first_name: first_name,
      last_name: last_name,
      playcelet_id: mac_address,
      color: color,
      color_name: color_name,
      app: app.try(:name),
      located_at: located_at_timestamp,
      last_app: last_app.try(:name),
      default_play_network_id: default_play_network_id,
    }
    result.merge!(family: family.as_json) if options[:family]
    result.merge!(parents: parents.map(&:as_json)) if options[:parent] || options[:parents]
    result.merge!(supervisor: supervisor.as_json) if options[:supervisor]
    result.merge!(place: family.as_json) if options[:place] || options[:family]
    result.merge!(play_networks: list_play_networks.as_json) if options[:play_networks]
    result.merge!(default_play_network: default_play_network.as_json) if options[:default_play_network]
    result
  end

  private

  def prepare_color_name
    self.color_name = PlayceletColors.name_by_color(self.color)
  end

  def convert_mac_address_to_uppercase
    self.mac_address = (self.mac_address || '').upcase
  end

end
