class Message < ActiveRecord::Base
  module MessageTypes
  	CHECK_IN = 'check-in'
  	CHECK_OUT = 'check-out'
  	CONFIRMATION = 'confirmation'
    NEIGHBORS_INVITATION = 'neighbor-invitation'
    ACCEPT_NEIGHBORS_INVITATION = 'accept-neighbor-invitation'
    CANCEL_NEIGHBORS_INVITATION = 'cancel-neighbor-invitation'
    DECLINE_NEIGHBORS_INVITATION = 'reject-neighbor-invitation'
    PLAY_INVITATION = 'play-invitation'
    ACCEPT_PLAY_INVITATION = 'accept-play-invitation'
    CANCEL_PLAY_INVITATION = 'cancel-play-invitation'
    DECLINE_PLAY_INVITATION = 'reject-play-invitation'
    RSVP = 'rsvp'
    ON_THE_WAY = 'on-the-way'
    COME_HOME = 'come-home'
    DUE_HOME = 'due-home'
    OVERDUE_HOME = 'overdue-home'
    OUT_OF_CONTACT = 'out-of-contact'
    CHILD_IS_HERE = 'child-is-here'
    LIGHT = 'light'
    TEXT = 'text'

    LIST = [
      CHECK_IN,
      CHECK_OUT,
      CONFIRMATION,
      RSVP,
      NEIGHBORS_INVITATION,
      ACCEPT_NEIGHBORS_INVITATION,
      CANCEL_NEIGHBORS_INVITATION,
      DECLINE_NEIGHBORS_INVITATION,
      PLAY_INVITATION,
      ACCEPT_PLAY_INVITATION,
      CANCEL_PLAY_INVITATION,
      DECLINE_PLAY_INVITATION,
    ].map{|mt| [mt.split('-').join(' ').titleize, mt]}
  end

  module Statuses
    NEW = 'new'
    DELIVERED = 'delivered'
  end
  scope :recent, -> {where(status: Statuses::NEW)}
  def mark_delivered!
    update_attribute(:status, Message::Statuses::DELIVERED)
  end

  before_validation :prepare_message
  after_create :process_message
  attr_accessor :message_was_processed

  belongs_to :child
  belongs_to :app
  delegate :supervisor, :to => :app, :allow_nil => true
  belongs_to :message
  belongs_to :recipient_app, class_name: 'App'
  belongs_to :family
  belongs_to :invited_family, class_name: 'Family'
  belongs_to :recipient_child, class_name: 'Child'
  belongs_to :invitation, polymorphic: true

  validates :message_type, presence: true
  validate :parent_permissions_for_child

  class << self
    def by_message_type(message_type)
      if message_type
        Message.where(message_type: message_type)
      else
        Message.where({})
      end
    end

    def after(message_time)
      message_time_field = Message.arel_table[:message_time]
      if message_time
        Message.where(message_time_field.gteq(message_time)).order('id ASC')
      else
        Message.order('id DESC')
      end
    end

    def send_come_home(_app, _recipient_child, _located_at=nil)
      _located_at ||= Time.now
      Message.create({
        message_type: MessageTypes::COME_HOME,
        recipient_child: _recipient_child,
        app: _app,
        message_time: _located_at,
      })
    end

    def send_come_home!(_app, _recipient_child, _located_at=nil)
      _located_at ||= Time.now
      Message.create!({
        message_type: MessageTypes::COME_HOME,
        recipient_child: _recipient_child,
        app: _app,
        message_time: _located_at,
      })
    end

  	def send_check_in(_child, _app, _located_at=nil)
      _located_at ||= Time.now
  	  Message.create!({
        message_type: MessageTypes::CHECK_IN,
        child: _child,
        app: _app,
        message_time: _located_at,
      })
  	end

  	def send_check_out(_child, _app, _located_at=nil)
      _located_at ||= Time.now
  	  Message.create!({
        message_type: MessageTypes::CHECK_OUT,
        child: _child,
        app: _app,
        message_time: _located_at,
      })
  	end

  	def receive_confirmation(_child, _app, _message_id, _message_time=nil)
      _message_time ||= Time.now
  	  Message.create!({
        message_type: MessageTypes::CONFIRMATION,
        message: _message,
        child: _child,
        app: _app,
        message_time: _message_time,
      })
  	end

    def create_neighbors_invitation_message(_family, _invited_family, _invitation_text, _app, _invited_at=nil)
      _invited_at ||= Time.now
      Message.create!({
        message_type: MessageTypes::NEIGHBORS_INVITATION,
        message_text: _invitation_text,
        family: _family,
        invited_family: _invited_family,
        app: _app,
        message_time: _invited_at,
      })
    end
    
    def accept_neighbors_invitation_message(_neighbors_invitation_id, _app, _response_text, _respond_at=nil)
      _respond_at = Time.now
      Message.create!({
        message_type: MessageTypes::ACCEPT_NEIGHBORS_INVITATION,
        message_text: _response_text,
        invitation_id: _neighbors_invitation_id,
        app: _app,
        message_time: _respond_at,
      })
    end
    
    def cancel_neighbors_invitation_message(_neighbors_invitation_id, _app, _response_text, _respond_at=nil)
      _respond_at ||= Time.now
      Message.create!({
        message_type: MessageTypes::CANCEL_NEIGHBORS_INVITATION,
        message_text: _response_text,
        invitation_id: _neighbors_invitation_id,
        app: _app,
        message_time: _respond_at,
      })
    end

    def decline_neighbors_invitation_message(_neighbors_invitation_id, _app, _response_text, _respond_at=nil)
      _respond_at ||= Time.now
      Message.create!({
        message_type: MessageTypes::DECLINE_NEIGHBORS_INVITATION,
        message_text: _response_text,
        invitation_id: _neighbors_invitation_id,
        app: _app,
        message_time: _respond_at,
      })
    end

    def create_play_invitation_message(_child, _invited_child, _invitation_text, _app, _duration=nil, _end_time=nil, _invited_at=nil)
      _invited_at ||= Time.now
      play_invitations_params = {
        message_type: MessageTypes::PLAY_INVITATION,
        family: _child.family,
        child: _child,
        app: _app,
        invited_family: _invited_child.family,
        recipient_child: _invited_child,
        message_time: _invited_at,
      }
      play_invitations_params.merge!(message_text: _invitation_text) if _invitation_text
      play_invitations_params.merge!(duration: _duration) if _duration
      play_invitations_params.merge!(end_time: _end_time) if _end_time
      Message.create!(play_invitations_params)
    end
  end

  def parent
    app ? app.supervisor : nil
  end

  def to_s
    [message_type, id.to_s].join(' ')
  end

  def as_json(options = {})
    {
      message_type: message_type,
      timestamp: timestamp,
      received_at: received_at,
    }
  end

  def timestamp=(_timestamp)
    self.message_time = Time.at(_timestamp)
  end

  def timestamp
    self.message_time.to_time.to_i
  end

  def check_in?
    MessageTypes::CHECK_IN == self.message_type
  end

  def check_out?
    MessageTypes::CHECK_OUT == self.message_type
  end

  def message_confirmation?
    MessageTypes::CONFIRMATION == self.message_type
  end

  def create_play_invitation?
    MessageTypes::PLAY_INVITATION == self.message_type
  end

  def update_play_invitation?
    false
  end

  def create_neighbors_invitation?
    MessageTypes::NEIGHBORS_INVITATION == self.message_type
  end

  def accept_neighbors_invitation?
    MessageTypes::ACCEPT_NEIGHBORS_INVITATION == self.message_type
  end

  def cancel_neighbors_invitation?
    MessageTypes::CANCEL_NEIGHBORS_INVITATION == self.message_type
  end

  def decline_neighbors_invitation?
    MessageTypes::DECLINE_NEIGHBORS_INVITATION == self.message_type
  end

  def update_neighbors_invitation?
    [
      MessageTypes::ACCEPT_NEIGHBORS_INVITATION,
      MessageTypes::CANCEL_NEIGHBORS_INVITATION,
      MessageTypes::DECLINE_NEIGHBORS_INVITATION,
    ].include?(self.message_type)
  end

  def received!
    self.update_attribute(:status, Statuses::DELIVERED)
  end

  def come_home?
    MessageTypes::COME_HOME == self.message_type
  end

  private

  def prepare_message
    if check_in?
    elsif check_out?
    elsif message_confirmation?
    elsif update_neighbors_invitation?
      neighbors_invitation = NeighborsInvitation.find(self.invitation_id)
      self.family = neighbors_invitation.family
      self.invited_family = neighbors_invitation.invited_family
      self.message_text ||= "Become at #{family.name}’s neighbor"
    elsif create_play_invitation?
      self.message_text ||= PlayInvitation.default_invitation_text(self.child, self.recipient_child, self.end_time)
    elsif update_play_invitation?
      self.message_text ||= PlayInvitation.default_invitation_text(self.child, self.recipient_child, self.end_time)
    end
  end

  def process_message
    return if message_was_processed
    if check_in?
      Info.send_check_in(self) unless self.app == child.app
      child.check_in(self.app, message_time)
    elsif check_out?
      child.check_out(app, message_time)
      Info.send_check_out(self)
    elsif message_confirmation?
      Info.find(self.message_id).update_attribute!(status: Statuses::DELIVERED)
    elsif create_neighbors_invitation?
      self.invitation = NeighborsInvitation.create!({
        family: self.family,
        invited_family: self.invited_family,
        invitation_text: self.message_text,
        invited_at: self.message_time,
        user: self.parent.user,
      })
      self.message_was_processed = true
      self.save!
    elsif update_neighbors_invitation?
      neighbors_invitation = NeighborsInvitation.find(self.invitation_id)
      _status = if accept_neighbors_invitation?
        NeighborsInvitation::Statuses::ACCEPTED
      elsif cancel_neighbors_invitation?
        NeighborsInvitation::Statuses::CANCELED
      elsif decline_neighbors_invitation?
        NeighborsInvitation::Statuses::REJECTED
      end
      neighbors_invitation.update_attributes({
        status: _status,
        respond_by: parent.user,
        respond_at: message_time,
        response_text: message_text,
      })
    elsif create_play_invitation? && !self.accepted_at

      self.invitation = PlayInvitation.create!({
        child: self.child,
        invited_child: self.recipient_child,
        invitation_text: self.message_text,
        invited_at: self.message_time,
        app: self.app,
        duration: self.duration,
        end_time: self.end_time,
      })
      self.message_text ||= PlayInvitation.default_invitation_text(self.child, self.recipient_child, self.end_time)
      self.message_was_processed = true
      self.save!
    elsif come_home?
      play_invitation = recipient_child.play_invitations.after_come.before_complete.first
      play_invitation.due_home(parent)
    end
  end

  def parent_permissions_for_child
    if come_home?
      if self.parent.family_id != recipient_child.family_id
        errors.add(:base, "Parent can send 'Come home' only to his children")
      elsif recipient_child.play_invitations.blank?
        errors.add(:base, "Parent can send 'Come home' only to his children if it is away")
      else
        play_invitation = recipient_child.play_invitations.after_come.before_complete.first
        unless play_invitation
          errors.add(:base, "Parent can send 'Come home' only to his children if it is away and before come home")
        end
      end
    end
  end

end
