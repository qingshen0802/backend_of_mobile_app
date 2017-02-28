class PlayInvitation < ActiveRecord::Base
  TIME_TO_REPEAT_NOTIFICATIONS = 15.seconds

  module Statuses
  	NEW          = '0. new'
  	ACCEPTED     = '1. accepted'
  	CANCELED     = '8. canceled'
    REJECTED     = '8. rejected'
    RSVP         = '2. on the way'
    COME         = '3. come'
    FINISHED     = '4. finished'
    DUE_HOME     = '5. due_home'
    OVERDUE_HOME = '5. overdue_home'
    COMPLETE     = '9. complete'
    CLOSED       = 'a. closed'
    DELETED      = 'b. deleted'

    NAME_BY_VALUE = {
      NEW          => :new,
      ACCEPTED     => :accepted,
      CANCELED     => :canceled,
      REJECTED     => :rejected,
      RSVP         => :on_the_way,
      COME         => :come,
      FINISHED     => :finished,
      DUE_HOME     => :due_home,
      OVERDUE_HOME => :overdue_home,
      COMPLETE     => :complete,
      DELETED      => :deleted,
    }
  end
  module EndTimePeriods
    HALF_HOUR = 30
    HOUR = 60
    HOUR_AND_A_HALF = 90
    TWO_HOURS = 120
    TWO_HOURS_AND_A_HALF = 150
    THREE_HOURS = 180
    THREE_HOURS_AND_A_HALF = 210
    FOUR_HOURS = 240
    LIST = [
      HALF_HOUR,
      HOUR,
      HOUR_AND_A_HALF,
      TWO_HOURS,
      TWO_HOURS_AND_A_HALF,
      THREE_HOURS,
      THREE_HOURS_AND_A_HALF,
      FOUR_HOURS
    ]
    NAME_BY_VALUE = {
      HALF_HOUR => '30 minutes',
      HOUR => '1 hour',
      HOUR_AND_A_HALF => '1 hour and a half',
      TWO_HOURS => '2 hours',
      TWO_HOURS_AND_A_HALF => '2 hours and a half',
      THREE_HOURS => '3 hours',
      THREE_HOURS_AND_A_HALF => '3 hours and a half',
      FOUR_HOURS => '4 hours',
    }

    class << self
      def all
        LIST.map{ |value| [ NAME_BY_VALUE[value], value ] }
      end
    end
  end

  belongs_to :child
  has_one :family, through: :child
  belongs_to :invited_child, class_name: 'Child'
  belongs_to :app
  has_one :parent, through: :app
  belongs_to :respond_by, class_name: 'Parent'
  belongs_to :place

  before_validation :set_default_status
  before_validation :set_default_place
  before_validation :set_default_invitation_text
  before_validation :set_end_time
  validates :app_id, presence: true
  validates :child_id, presence: true
  validates :invited_child_id, presence: true
  validates :duration, presence: true
  validate :check_permissions_for_status_update
  after_save :schedule_play_invitation_messages_and_notifications

  def parent
    app ? app.supervisor : nil
  end

  def parent_id
    app ? app.supervisor.id : nil
  end

  def parent_id=(value)
    self.app = Parent.find(value).app
  end

  def parent=(value)
    self.app  = value.app
  end

  def accept(parent, _end_time=nil, _duration=nil)
    new_attrs = {respond_by: parent, status: Statuses::ACCEPTED}
    new_attrs.merge!(end_time: _end_time) if _end_time
    new_attrs.merge!(duration: _duration) if _duration
  	self.update_attributes(new_attrs)
    invited_parents.each do |p|
      Info.create_play_invitation_accepted_notification(self, p) if p != parent
    end
    parents.each do |p|
      Info.create_play_invitation_accepted_notification(self, p)
    end
  end

  def accept_by_admin(_end_time=nil, _duration=nil)
    new_attrs = {respond_by: invited_child.family.parents.first, status: Statuses::ACCEPTED}
    new_attrs.merge!(end_time: _end_time) if _end_time
    new_attrs.merge!(duration: _duration) if _duration
    self.update_attributes(new_attrs)
    parents.each do |p|
      Info.create_play_invitation_accepted_notification(self, p)
    end
  end

  def reject_by_admin
    self.update_attributes(status: Statuses::REJECTED)
  end

  def decline(parent)
    self.update_attributes(respond_by: parent, status: Statuses::REJECTED)
  end

  def cancel(parent)
    self.update_attributes(respond_by: parent, status: Statuses::CANCELED)
  end

  def come(parent)
    if self.family == parent.family
      # add EventLog
      self.update_attributes(status: Statuses::COME)
      create_play_invitation_notification_come
    end
  end

  def complete!(parent)
    if self.invited_family == parent.family
      # add EventLog
      self.update_attributes(status: Statuses::COMPLETE)
      create_play_invitation_notification_come
    end
  end

  def ended?
    self.end_time <= Time.now.utc
  end

  def deleted?
    self.status == Statuses::DELETED
  end

  def due_home(parent)
    if self.invited_child.family == parent.family
      self.update_attributes(status: Statuses::DUE_HOME)
      create_play_invitation_notification_due_home
    end
  end

  def remove!
    self.update_attributes(status: Statuses::DELETED)
  end

  scope :pending, -> {where(status: Statuses::NEW)}
  scope :declined, -> {where(status: Statuses::REJECTED)}
  scope :accepted, -> {where(status: Statuses::ACCEPTED)}
  scope :cancelled, -> {where(status: Statuses::ACCEPTED)}
  scope :rsvp, -> {where(status: Statuses::RSVP)}
  scope :come, -> {where(status: Statuses::COME)}
  scope :ended, -> {where(status: Statuses::FINISHED)}
  scope :due_home, -> {where(status: Statuses::DUE_HOME)}
  scope :active, -> {where(status: Statuses::DUE_HOME)}
  scope :ended_or_due_home_or_overdue_home,  -> {where(status: [Statuses::OVERDUE_HOME, Statuses::DUE_HOME, Statuses::FINISHED])}

  class << self
    def active()
      status_field = PlayInvitation.arel_table[:status]
      PlayInvitation.where(status_field.lt(Statuses::CLOSED))
    end

    def after_come()
      status_field = PlayInvitation.arel_table[:status]
      PlayInvitation.where(status_field.gteq(Statuses::COME))
    end

    def accepted_or_after()
      status_field = PlayInvitation.arel_table[:status]
      PlayInvitation.where(status_field.gteq(Statuses::ACCEPTED))
    end

    def before_come()
      status_field = PlayInvitation.arel_table[:status]
      PlayInvitation.where(status_field.lt(Statuses::COME))
    end

    def before_complete()
      status_field = PlayInvitation.arel_table[:status]
      PlayInvitation.where(status_field.lt(Statuses::COMPLETE))
    end

    def income_and_outcome_by_family(_family)
      PlayInvitation.income_and_outcome_by_children(_family.children.map(&:id))
    end

    def income_and_outcome_by_children(_children_ids)
      PlayInvitation.where("(child_id = ANY(ARRAY[#{_children_ids.join(',')}])) OR (invited_child_id = ANY(ARRAY[#{_children_ids.join(',')}]))")
    end

    def nearest_start_time
      result_time = Time.now
      minutes = result_time.min
      hour = result_time.hour
      if minutes.zero?
        puts "zero"
      elsif (0 < minutes) && (minutes < 30)
        result_time = result_time.change({:min => 30 , :sec => 0 })
      elsif (30 < minutes) && (minutes < 60)
        result_time = result_time.change({:min => 0 , :sec => 0 })
        result_time += 1.hour
      end
      result_time.utc
    end

    def default_invitation_text(child, invited_child, _end_time=nil)
      ["Play at #{child}’s house", (_end_time ? "until #{convert_time _end_time}" : nil)].compact.join(' ')
    end

    def convert_time(_time)
      _time.in_time_zone("Pacific Time (US & Canada)").strftime '%I:%M %p'
    end
  end

  def status_name
    Statuses::NAME_BY_VALUE[status]
  end

  def duration_name
    EndTimePeriods::NAME_BY_VALUE[duration]
  end

  def proposed_start_time
    @proposed_start_time ||= self.proposed_end_time ? (self.proposed_end_time - self.proposed_duration.minutes) : PlayInvitation.nearest_start_time
  end

  def set_end_time
    self.end_time ||= (self.proposed_start_time + duration.to_i.minutes) if duration
    self.duration = (((self.end_time - self.proposed_start_time).to_i / 60 + 15) / 30 * 30)  if self.end_time && self.duration.nil?
    self.proposed_end_time ||= self.end_time
    self.proposed_duration ||= self.duration
  end

  def to_s
    "#{child} invites #{invited_child}"
  end

  def as_json(options={})
    {
      id: id,
      parent: parent.as_json,
      child: child.as_json,
      respond_by: respond_by.as_json,
      invited_child: invited_child.as_json,
      status: status_name,
      duration: duration,
      duration_name: duration_name,
      end_time: end_time.to_time.utc.to_i,
      proposed_duration: proposed_duration,
      proposed_end_time: proposed_end_time.to_time.utc.to_i,
      start_time: proposed_start_time.utc.to_i,
      created_at: created_at.utc.to_i,
    }
  end

  def check_permissions_for_status_update
    if [Statuses::ACCEPTED].include?(status) && (respond_by.family != invited_child.family)
      self.errors.add(:base, "Only invited family member can accept invitation")
    elsif [Statuses::CANCELED].include?(status) && (respond_by.family != child.family)
      self.errors.add(:base, "Only initiator family member can cancel play invitation")
    elsif [Statuses::REJECTED].include?(status) && (respond_by.family != invited_child.family)
      self.errors.add(:base, "Only invited family member can reject invitation")
    elsif [Statuses::ACCEPTED].include?(status) && (Statuses::COME <= status_was)
      self.errors.add(:base, "You can accept only new invitation")
    elsif [Statuses::CANCELED].include?(status) && (Statuses::COME <= status_was)
      self.errors.add(:base, "You can cancel only new invitation")
    elsif [Statuses::REJECTED].include?(status) && (Statuses::COME <= status_was)
      self.errors.add(:base, "You can reject only new invitation")
    else
    end
  end

  def set_default_status
    self.status ||= Statuses::NEW
  end

  def set_default_place
    self.place_id ||= self.child.family_id
  end

  def set_default_invitation_text
    self.invitation_text ||= PlayInvitation.default_invitation_text(self.child, self.invited_child, self.end_time)
  end

  def parent_id=(_parent_id)
    _parent = Parent.find(_parent_id)
    self.app = _parent.app
  end

  def family_id
    family ? family.id : nil
  end

  def parents
    family.parents
  end

  def invited_family
  	invited_child.family
  end

  def invited_parents
  	invited_family.parents
  end

  def invited_parent
    invited_parents.first if invited_parents
  end

  def new?
    status == Statuses::NEW
  end

  def accepted?
  	status == Statuses::ACCEPTED
  end

  def schedule_play_invitation_messages_and_notifications
    unless notified_at
      update_attribute(:notified_at, Time.now)
      send_play_invitation_messages
      send_play_invitation_notification
      send_end_time_notification
    end
  end

  def send_play_invitation_messages
    parents.each do |p|
      Info.create_play_invitation_notification(self, p) if p != parent
    end
    invited_parents.each do |p|
      Info.create_play_invitation_notification(self, p)
    end
  end

  def send_play_invitation_notification
    create_play_invitation_notification
  end

  def create_play_invitation_notification
    if [Statuses::NEW, Statuses::ACCEPTED].include?(self.status)
      self.update_attribute(:status, Statuses::RSVP) if [Statuses::ACCEPTED].include?(self.status)
      Info.create_play_invitation_notification_to_invited(self)
      Info.create_play_invitation_notification_to_author(self)
      create_play_invitation_notification_rsvp
    end
  end

  def create_play_invitation_notification_rsvp
    Info.create_play_invitation_notification_to_invited_rsvp(self)
    self.update_attribute(:status, Statuses::RSVP) if [Statuses::ACCEPTED].include?(self.status)
    if [Statuses::ACCEPTED, Statuses::RSVP].include?(self.status)
      Info.create_play_invitation_notification_to_author_rsvp(self)
      Info.create_play_invitation_notification_on_the_way_to_rsvp(self)
    end
    create_play_invitation_notification_rsvp if [Statuses::NEW, Statuses::ACCEPTED, Statuses::RSVP].include?(self.status)
  end
  handle_asynchronously :create_play_invitation_notification_rsvp, :run_at => Proc.new { TIME_TO_REPEAT_NOTIFICATIONS.from_now }

  def create_play_invitation_notification_come
    if [Statuses::COME].include?(self.status)
      Info.create_play_invitation_notification_come_to_invited(self)
      Info.create_play_invitation_notification_come_to_author(self)
    end
  end
  handle_asynchronously :create_play_invitation_notification_come

  def send_end_time_notification
    if Statuses::ACCEPTED <= self.status
      self.update_attributes(status: Statuses::DUE_HOME)
      family.parents do |parent|
        Info.create_play_invitation_notification_end_time_to_author(self, parent)
        EventLog.infoCreatePlayInvitationNotificationDueHomeToAuthor(parent, self)
      end
      invited_family.parents do |invited_parent|
        Info.create_play_invitation_notification_end_time_to_invited(self, invited_parent)
        EventLog.infoCreatePlayInvitationNotificationDueHomeToInvited(invited_parent, self)
      end
      create_play_invitation_notification_due_home
    end
  end
  handle_asynchronously :send_end_time_notification, :run_at => Proc.new { |play_invitation| play_invitation.end_time }

  def create_play_invitation_notification_due_home
    if [Statuses::DUE_HOME].include?(self.status)
      Info.create_play_invitation_notification_due_home_to_invited(self)
      repeat_play_invitation_notification_due_home
    end
  end

  def repeat_play_invitation_notification_due_home
    create_play_invitation_notification_due_home
  end
  handle_asynchronously :repeat_play_invitation_notification_due_home, :run_at => Proc.new { TIME_TO_REPEAT_NOTIFICATIONS.from_now }

  def create_play_invitation_notification_come_home
    if [Statuses::FINISHED, Statuses::DUE_HOME, Statuses::OVERDUE_HOME].include?(self.status)
      invited_parents.each do |p|
        Info.create_play_invitation_notification_came_home_to_invited(self, p)
        EventLog.infoCreatePlayInvitationNotificationCompletedToInvited(p, self)
      end
      parents.each do |p|
        Info.create_play_invitation_notification_came_home_to_author(self, p)
        EventLog.infoCreatePlayInvitationNotificationCompletedToAuthor(p, self)
      end
    end
  end
  handle_asynchronously :create_play_invitation_notification_come_home

end
