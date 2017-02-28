class Info < ActiveRecord::Base
  ALLOWED_INFOS = [
    Message::MessageTypes::PLAY_INVITATION,
    Message::MessageTypes::LIGHT,
    Message::MessageTypes::TEXT,
  ]

  belongs_to :message
  belongs_to :recipient_child, class_name: 'Child'
  belongs_to :child
  belongs_to :app
  delegate :supervisor, :to => :app, :allow_nil => true
  belongs_to :sender_app, :class_name => 'App'
  belongs_to :family
  belongs_to :invited_family, class_name: 'Family'
  belongs_to :invitation, polymorphic: true

  validates :message_type, presence: true

  scope :recent, -> { where(status: Message::Statuses::NEW).order('id DESC') }
  def mark_delivered!
    update_attribute(:status, Message::Statuses::DELIVERED)
  end

  class << self
    def by_app_id(app_id)
      if app_id
        Info.where(app_id: app_id)
      else
        Info.where({})
      end
    end

    def by_child_id(child_id)
      if child_id
        Info.where(child_id: child_id)
      else
        Info.where({})
      end
    end

    def by_recipient_child_id(recipient_child_id)
      if recipient_child_id
        Info.where(recipient_child_id: recipient_child_id)
      else
        Info.where({})
      end
    end

    def by_recipient_child_id_only(recipient_child_id)
      if recipient_child_id
        Info.where(recipient_child_id: recipient_child_id, app_id: nil)
      else
        Info.where({})
      end
    end

    def by_message_type(message_type)
      if message_type
        Info.where(message_type: message_type)
      else
        Info.where({})
      end
    end

    def by_display_type(display_type)
      if display_type
        Info.where(display_type: display_type)
      else
        Info.where({})
      end
    end

    def after(message_time)
      message_time_field = Info.arel_table[:message_time]
      if message_time
        Info.where(message_time_field.gteq(message_time)).order('id ASC')
      else
        Info.order('id DESC')
      end
    end

    def send_check_in(_message)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::TEXT)
      app_received = false
      _message.child.parents.each do |parent|
        app_received = true if _message.app == parent.app
        _message_text = "#{_message.child} checked in with #{_message.app.supervisor}"
        EventLog.infoSendCheckInToParent(_message.app.supervisor, parent, _message.child, _message_text)
        Info.create!({
          message_type: Message::MessageTypes::TEXT,
          message_text: _message_text,
          display_type: Message::MessageTypes::CHECK_IN,
          app: parent.app,
          sender_app: _message.app,
          child: _message.child,
          message_time: _message.message_time,
        })
      end
      unless app_received
        if _message.app.supervisor.can_receive_info_about?(_message.child)
          _message_text = "#{_message.child} checked in with #{_message.app.supervisor}"
          EventLog.infoSendCheckInToSupervisor(_message.app.supervisor, _message.child, _message_text)
          Info.create!({
            message_type: Message::MessageTypes::TEXT,
            message_text: _message_text,
            display_type: Message::MessageTypes::CHECK_IN,
            app: _message.app,
            sender_app: _message.app,
            child: _message.child,
            message_time: _message.message_time,
          })
        end
      end
    end

    def send_check_out(message)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::CHECK_OUT)
      message.child.parents.each do |parent|
      	Info.create!({
      	  message_type: Message::MessageTypes::CHECK_OUT,
      	  app: parent.app,
      	  sender_app: message.app,
      	  child: message.child,
          message_time: message.message_time,
      	})
      end
    end

    def child_is_here(_child, _app)
      Info.create!({
        message_type: Message::MessageTypes::TEXT,
        display_type: Message::MessageTypes::CHILD_IS_HERE,
        message_text: "#{_child} is here!",
        app: _app,
        child: _child,
        message_time: Time.now.utc,
      })
    end

    def child_is_out_of_contact(_child, _app)
      _message_text = "#{_child} is out of contact!"
      EventLog.infoChildIsOutOfContact(_child, _app.supervisor, _message_text)
      Info.create!({
        message_type: Message::MessageTypes::TEXT,
        display_type: Message::MessageTypes::OUT_OF_CONTACT,
        message_text: _message_text,
        app: _app,
        child: _child,
        message_time: Time.now.utc,
      })
    end

    def create_initiated_neighbors_invitation_message(neighbors_invitation, supervisor)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::NEIGHBORS_INVITATION)
      Info.create!({
        message_type: Message::MessageTypes::NEIGHBORS_INVITATION,
        message_time: neighbors_invitation.invited_at,
        message_text: neighbors_invitation.invitation_text,
        display_type: Message::MessageTypes::NEIGHBORS_INVITATION,
        family: neighbors_invitation.family,
        invited_family: neighbors_invitation.invited_family,
        app: supervisor.app,
        sender_app: neighbors_invitation.user.app,
      })
    end

    def create_invited_neighbors_invitation_message(neighbors_invitation, parent)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::NEIGHBORS_INVITATION)
      Info.create!({
        message_text: neighbors_invitation.invitation_text,
        message_type: Message::MessageTypes::TEXT,
        message_time: neighbors_invitation.invited_at,
        display_type: Message::MessageTypes::NEIGHBORS_INVITATION,
        family: neighbors_invitation.family,
        invited_family: neighbors_invitation.invited_family,
        app: parent.app,
        sender_app: neighbors_invitation.user.app,
      })
    end

    def create_play_invitation_notification(play_invitation, parent)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::PLAY_INVITATION)
      return if play_invitation.ended? || play_invitation.deleted?
      info = Info.create!({
        message_type: Message::MessageTypes::TEXT,
        message_time: play_invitation.invited_at,
        message_text: play_invitation.invitation_text,
        display_type: Message::MessageTypes::PLAY_INVITATION,
        family: play_invitation.family,
        invited_family: play_invitation.invited_family,
        child: play_invitation.child,
        recipient_child: play_invitation.invited_child,
        app: parent.app,
        sender_app: play_invitation.app,
        color: play_invitation.child.color,
        light_mode: PlayceletLightingModes::PLAY_INVITATION_RECEIVED,
      })
      EventLog.infoCreatePlayInvitationNotification(parent, info, nil, {parent1_id: parent.id, family1_id: play_invitation.family.id, family2_id: play_invitation.invited_family.id, child1_id: play_invitation.child.id, child2_id: play_invitation.invited_child.id})
      info
    end

    def create_play_invitation_accepted_notification(play_invitation, parent)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::TEXT)
      return if play_invitation.ended? || play_invitation.deleted?
      info = Info.create!({
        message_type: Message::MessageTypes::TEXT,
        message_time: play_invitation.invited_at,
        message_text: "#{play_invitation.invited_family} accepted play invite for #{play_invitation.invited_child}",
        display_type: Message::MessageTypes::PLAY_INVITATION,
        family: play_invitation.family,
        invited_family: play_invitation.invited_family,
        child: play_invitation.child,
        recipient_child: play_invitation.invited_child,
        app: parent.app,
        sender_app: play_invitation.app,
        color: play_invitation.invited_child.color,
        light_mode: PlayceletLightingModes::PLAY_INVITATION_RECEIVED,
      })
      EventLog.infoCreatePlayInvitationNotificationAccepted(parent, info, nil, {parent1_id: parent.id, family1_id: play_invitation.family.id, family2_id: play_invitation.invited_family.id, child1_id: play_invitation.child.id, child2_id: play_invitation.invited_child.id})
      info
    end

    def create_play_invitation_notification_to_invited(play_invitation, _light_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::LIGHT)
      return if play_invitation.ended? || play_invitation.deleted?
      _light_at ||= Time.now
      return unless Info.recent.by_recipient_child_id(play_invitation.invited_child.id).by_message_type(Message::MessageTypes::LIGHT).blank?
      info = Info.create!({
        message_type: Message::MessageTypes::LIGHT,
        message_time: _light_at,
        child: play_invitation.child,
        recipient_child: play_invitation.invited_child,
        color: play_invitation.child.color,
        light_mode: PlayceletLightingModes::PLAY_INVITATION_NOTIFICATION_FOR_INVITED_AT_HOME,
      })
      EventLog.infoCreatePlayInvitationNotification(play_invitation.app.supervisor, info, nil, {parent1_id: play_invitation.app.supervisor.id, family1_id: play_invitation.family.id, family2_id: play_invitation.invited_family.id, child1_id: play_invitation.child.id, child2_id: play_invitation.invited_child.id})
      info
    end

    def create_play_invitation_notification_to_author(play_invitation, _light_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::LIGHT)
      return if play_invitation.ended? || play_invitation.deleted?
      _light_at ||= Time.now
      return unless Info.recent.by_recipient_child_id(play_invitation.child.id).by_message_type(Message::MessageTypes::LIGHT).blank?
      info = Info.create!({
        message_type: Message::MessageTypes::LIGHT,
        message_time: _light_at,
        child: play_invitation.invited_child,
        recipient_child: play_invitation.child,
        color: play_invitation.invited_child.color,
        light_mode: PlayceletLightingModes::PLAY_INVITATION_NOTIFICATION_FOR_AUTHOR_AT_HOME,
      })
      info
    end

    def create_play_invitation_notification_on_the_way_to_rsvp(play_invitation, _sent_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::TEXT)
      return if play_invitation.ended? || play_invitation.deleted?
      _sent_at ||= Time.now
      return unless Info.recent.by_child_id(play_invitation.invited_child.id).by_message_type(Message::MessageTypes::TEXT).by_display_type(Message::MessageTypes::ON_THE_WAY).blank?
      info = Info.create!({
        message_type: Message::MessageTypes::TEXT,
        message_time: _sent_at,
        display_type: Message::MessageTypes::ON_THE_WAY,
        message_text: "#{play_invitation.invited_child} is on the way",
        app: play_invitation.app,
        child: play_invitation.invited_child,
      })
      info
    end

    def create_play_invitation_notification_to_invited_rsvp(play_invitation, _light_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::LIGHT)
      return if play_invitation.ended? || play_invitation.deleted?
      _light_at ||= Time.now
      return unless Info.recent.by_recipient_child_id(play_invitation.invited_child.id).by_message_type(Message::MessageTypes::LIGHT).blank?
      info = Info.create!({
        message_type: Message::MessageTypes::LIGHT,
        message_time: _light_at,
        child: play_invitation.child,
        recipient_child: play_invitation.invited_child,
        color: play_invitation.child.color,
        light_mode: PlayceletLightingModes::PLAY_INVITATION_NOTIFICATION_FOR_INVITED_AT_HOME_RSVP,
      })
      EventLog.infoCreatePlayInvitationNotificationRsvpToInvited(play_invitation.invited_parent, info)
      info
    end

    def create_play_invitation_notification_to_author_rsvp(play_invitation, _light_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::LIGHT)
      return if play_invitation.ended? || play_invitation.deleted?
      _light_at ||= Time.now
      return unless Info.recent.by_recipient_child_id(play_invitation.child.id).by_message_type(Message::MessageTypes::LIGHT).blank?
      info = Info.create!({
        message_type: Message::MessageTypes::LIGHT,
        message_time: _light_at,
        child: play_invitation.invited_child,
        recipient_child: play_invitation.child,
        color: play_invitation.invited_child.color,
        light_mode: PlayceletLightingModes::PLAY_INVITATION_NOTIFICATION_FOR_AUTHOR_AT_HOME_RSVP,
      })
      EventLog.infoCreatePlayInvitationNotificationRsvpToAuthor(play_invitation.parent, info)
      info
    end

    def create_play_invitation_notification_come_to_invited(play_invitation, _light_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::LIGHT)
      return if play_invitation.ended? || play_invitation.deleted?
      _light_at ||= Time.now
      info = Info.create!({
        message_type: Message::MessageTypes::LIGHT,
        message_time: _light_at,
        child: play_invitation.child,
        recipient_child: play_invitation.invited_child,
        color: play_invitation.child.color,
        light_mode: PlayceletLightingModes::PLAY_INVITATION_NOTIFICATION_CAME,
      })
      EventLog.infoCreatePlayInvitationNotificationComeToInvited(play_invitation.invited_parent, info)
      info
    end

    def create_play_invitation_notification_come_to_author(play_invitation, _light_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::LIGHT)
      return if play_invitation.ended? || play_invitation.deleted?
      _light_at ||= Time.now
      info = Info.create!({
        message_type: Message::MessageTypes::LIGHT,
        message_time: _light_at,
        child: play_invitation.invited_child,
        recipient_child: play_invitation.child,
        color: play_invitation.invited_child.color,
        light_mode: PlayceletLightingModes::PLAY_INVITATION_NOTIFICATION_CAME,
      })
      EventLog.infoCreatePlayInvitationNotificationComeToAuthor(play_invitation.parent, info)
      info
    end

    def create_play_invitation_notification_come_home_to_invited(play_invitation, _parent, _send_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::TEXT)
      return if play_invitation.deleted?
      _send_at ||= Time.now
      info = Info.create!({
        message_type: Message::MessageTypes::TEXT,
        message_time: _send_at,
        message_text: "#{play_invitation.invited_child} have came home",
        display_type: Message::MessageTypes::CHILD_IS_HERE,
        app: _parent,
      })
      info
    end

    def create_play_invitation_notification_came_home_to_author(play_invitation, _parent, _send_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::TEXT)
      return if play_invitation.deleted?
      _send_at ||= Time.now
      info = Info.create!({
        message_type: Message::MessageTypes::TEXT,
        message_time: _send_at,
        message_text: "#{play_invitation.invited_child} have came home",
        display_type: Message::MessageTypes::CHILD_IS_HERE,
        app: _parent,
      })
      info
    end


    def create_play_invitation_notification_come_home_to_author(play_invitation, _parent, _send_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::TEXT)
      return if play_invitation.deleted?
      _send_at ||= Time.now
      info = Info.create!({
        message_type: Message::MessageTypes::TEXT,
        message_time: _send_at,
        message_text: "#{play_invitation.invited_child} is due home",
        display_type: Message::MessageTypes::COME_HOME,
        app: _parent,
      })
      EventLog.infoCreatePlayInvitationNotificationComeToAuthor(play_invitation.parent, info)
      info
    end

    def create_play_invitation_notification_end_time_to_author(play_invitation, _parent, _send_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::TEXT)
      return if play_invitation.deleted?
      _send_at ||= Time.now
      info = Info.create!({
        message_type: Message::MessageTypes::TEXT,
        message_time: _send_at,
        message_text: "#{play_invitation.invited_child} is due home",
        display_type: Message::MessageTypes::DUE_HOME,
        app: _parent,
      })
      EventLog.infoCreatePlayInvitationNotificationDueHomeToAuthor(play_invitation.parent, info)
      info
    end

    def create_play_invitation_notification_end_time_to_invited(play_invitation, _parent, _send_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::TEXT)
      return if play_invitation.deleted?
      _send_at ||= Time.now
      info = Info.create!({
        message_type: Message::MessageTypes::TEXT,
        message_time: _send_at,
        message_text: "#{play_invitation.invited_child} is due home",
        display_type: Message::MessageTypes::DUE_HOME,
        app: _parent,
      })
      EventLog.infoCreatePlayInvitationNotificationDueHomeToInvited(play_invitation.invited_parent, info)
      info
    end

    def create_play_invitation_notification_due_home_to_invited(play_invitation, _light_at=nil)
      return unless ALLOWED_INFOS.include?(Message::MessageTypes::LIGHT)
      return if play_invitation.deleted?
      _light_at ||= Time.now
      info = Info.create!({
        message_type: Message::MessageTypes::LIGHT,
        message_time: _light_at,
        recipient_child: play_invitation.invited_child,
        color: play_invitation.invited_child.color,
        light_mode: PlayceletLightingModes::PLAY_INVITATION_NOTIFICATION_DUE_HOME,
      })
      EventLog.infoCreatePlayInvitationNotificationDueHomeToInvited(play_invitation.invited_parent, info)
      info
    end

  end

  def get_supervisor
    @get_supervisor ||= self.app ? self.app.supervisor : self.recipient_child.app ? self.recipient_child.app.supervisor : self.recipient_child.parents.first
  end

  def sender_supervisor
    sender_app.try(:supervisor)
  end

  def invited_child
    recipient_child
  end

  def light?
    Message::MessageTypes::LIGHT == self.message_type
  end

  def create_play_invitation?
    Message::MessageTypes::PLAY_INVITATION == self.message_type
  end

  def update_play_invitation?
    false
  end

  def create_neighbors_invitation?
    Message::MessageTypes::NEIGHBORS_INVITATION == self.message_type
  end

  def accept_neighbors_invitation?
    Message::MessageTypes::ACCEPT_NEIGHBORS_INVITATION == self.message_type
  end

  def cancel_neighbors_invitation?
    Message::MessageTypes::CANCEL_NEIGHBORS_INVITATION == self.message_type
  end

  def decline_neighbors_invitation?
    Message::MessageTypes::DECLINE_NEIGHBORS_INVITATION == self.message_type
  end

  def update_neighbors_invitation?
    [
      Message::MessageTypes::ACCEPT_NEIGHBORS_INVITATION,
      Message::MessageTypes::CANCEL_NEIGHBORS_INVITATION,
      Message::MessageTypes::DECLINE_NEIGHBORS_INVITATION,
    ].include?(self.message_type)
  end

  def as_json(options = {})
    result = {
      id: self.id,
      message_type: message_type,
      display_type: display_type,
      timestamp: timestamp,
      received_at: received_at,
      message_text: message_text,
      status: status,
    }
    result.merge!({
      family: family.as_json,
      invited_family: invited_family.as_json,
      sender_app: sender_app,
    }) if create_neighbors_invitation? || update_neighbors_invitation?
    if create_play_invitation? || update_play_invitation?
      result.merge!({
        invited_child: recipient_child,
        child: child,
        light_mode: light_mode,
        color: color,
      })
    elsif light?
      result.merge!({
        child: child,
        light_mode: light_mode,
        color: color,
      })
    end
    result
  end

  def timestamp=(_timestamp)
    self.message_time = Time.at(_timestamp)
  end

  def timestamp
    self.message_time.to_time.utc.to_i
  end

  def to_s
    [message_type, display_type].join(' ')
  end

end
