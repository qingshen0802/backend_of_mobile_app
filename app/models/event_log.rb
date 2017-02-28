class EventLog < ActiveRecord::Base
  MAX_STRING_INDEX = 254
  belongs_to :child1, class_name: 'Child'
  belongs_to :child2, class_name: 'Child'
  belongs_to :parent1, class_name: 'Parent'
  belongs_to :parent2, class_name: 'Parent'
  belongs_to :family1, class_name: 'Family'
  belongs_to :family2, class_name: 'Family'
  belongs_to :record, polymorphic: true
  belongs_to :initiator, polymorphic: true

  module EventTypes
    SIGN_OUT_ALREADY_SIGNED_IN_USER = :sign_out_already_signed_in_user
    SIGN_IN = :sign_in
    SIGN_OUT = :sign_out
    GET_STATUS = :get_status
    GET_INFOS = :get_infos
  	GET_LAST_INFO = :get_last_info
    GET_MESSAGES = :get_messages
    GET_PLAY_INVITATIONS = :get_play_invitations
    GET_LAST_PLAY_INVITATION = :get_play_invitation
    GET_PLAY_NETWORKS = :get_play_networks
    GET_FRIENDS = :get_play_networks

    CREATE_CHILD = :create_child
    UPDATE_CHILD = :update_child
    DESTROY_CHILD = :destroy_child

    CREATE_MESSAGE = :create_message
    CREATE_MESSAGE_CHECK_IN = :create_message_check_in
    CREATE_PLAY_INVITATION = :create_play_invitation
    ACCEPT_PLAY_INVITATION = :accept_play_invitation
    REJECT_PLAY_INVITATION = :reject_play_invitation
    CANCEL_PLAY_INVITATION = :cancel_play_invitation

    SEND_CHECK_IN_TO_PARENT = :send_check_in_to_parent
    SEND_CHECK_IN_TO_SUPERVISOR = :send_check_in_to_supervisor
    CHILD_IS_OUT_OF_CONTACT = :child_is_out_of_contact

    CHILD_CHECK_IN = :child_check_in
    CHILD_CHECK_OUT = :child_check_out
    CHILD_AUTO_CHECK_OUT = :child_auto_check_out
    CHILD_CHECK_COME_EVENT = :child_check_come_event

    PLAY_INVITATION_CREATE_NOTIFICATION = :play_invitation_create_notification
    PLAY_INVITATION_CREATE_NOTIFICATION_RSVP = :play_invitation_create_notification_rsvp
    PLAY_INVITATION_CREATE_NOTIFICATION_FINISHED = :play_invitation_create_notification_finished

    INFO_CREATE_PLAY_INVITATION_NOTIFICATION = :info_create_play_invitation_notification
    INFO_CREATE_PLAY_INVITATION_NOTIFICATION_ACCEPTED = :info_create_play_invitation_notification_accepted
    INFO_CREATE_PLAY_INVITATION_NOTIFICATION_TO_INVITED = :info_create_play_invitation_notification_to_invited
    INFO_CREATE_PLAY_INVITATION_NOTIFICATION_TO_AUTHOR = :info_create_play_invitation_notification_to_author
    INFO_CREATE_PLAY_INVITATION_NOTIFICATION_RSVP_TO_INVITED = :info_create_play_invitation_notification_rsvp_to_invited
    INFO_CREATE_PLAY_INVITATION_NOTIFICATION_RSVP_TO_AUTHOR = :info_create_play_invitation_notification_rsvp_to_author
    INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COME_TO_INVITED = :info_create_play_invitation_notification_come_to_invited
    INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COME_TO_AUTHOR = :info_create_play_invitation_notification_come_to_author
    INFO_CREATE_PLAY_INVITATION_NOTIFICATION_DUE_HOME_TO_INVITED = :info_create_play_invitation_notification_due_home_to_invited
    INFO_CREATE_PLAY_INVITATION_NOTIFICATION_DUE_HOME_TO_AUTHOR = :info_create_play_invitation_notification_due_home_to_author
    INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COMPLETED_TO_INVITED = :info_create_play_invitation_notification_completed_to_invited
    INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COMPLETED_TO_AUTHOR = :info_create_play_invitation_notification_completed_to_author

    CLEAR_3_DAYS_DATA = :clear_3_days_data
  end

  module ModeTypes
    ALL = ''
    READ = :read
    WRITE = :write

    BY_EVENT_TYPE = {
      EventTypes::SIGN_IN => WRITE,
      EventTypes::SIGN_OUT => WRITE,
      EventTypes::SIGN_OUT_ALREADY_SIGNED_IN_USER => WRITE,
      EventTypes::GET_STATUS => READ,
      EventTypes::GET_INFOS => READ,
      EventTypes::GET_LAST_INFO => READ,
      EventTypes::GET_MESSAGES => READ,
      EventTypes::GET_PLAY_INVITATIONS => READ,
      EventTypes::GET_LAST_PLAY_INVITATION => READ,
      EventTypes::GET_PLAY_NETWORKS => READ,
      EventTypes::GET_FRIENDS => READ,
      
      EventTypes::CREATE_MESSAGE => WRITE,
      EventTypes::CREATE_MESSAGE_CHECK_IN => WRITE,
      EventTypes::CREATE_PLAY_INVITATION => WRITE,
      EventTypes::ACCEPT_PLAY_INVITATION => WRITE,
      EventTypes::REJECT_PLAY_INVITATION => WRITE,
      EventTypes::CANCEL_PLAY_INVITATION => WRITE,

      EventTypes::SEND_CHECK_IN_TO_PARENT => WRITE,
      EventTypes::SEND_CHECK_IN_TO_SUPERVISOR => WRITE,
      EventTypes::CHILD_IS_OUT_OF_CONTACT => WRITE,

      EventTypes::CHILD_CHECK_IN => WRITE,
      EventTypes::CHILD_CHECK_OUT => WRITE,
      EventTypes::CHILD_AUTO_CHECK_OUT => WRITE,

      EventTypes::CREATE_CHILD => WRITE,
      EventTypes::UPDATE_CHILD => WRITE,
      EventTypes::DESTROY_CHILD => WRITE,

      EventTypes::PLAY_INVITATION_CREATE_NOTIFICATION => WRITE,
      EventTypes::PLAY_INVITATION_CREATE_NOTIFICATION_RSVP => WRITE,
      EventTypes::PLAY_INVITATION_CREATE_NOTIFICATION_FINISHED => WRITE,

      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION => WRITE,
      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_ACCEPTED => WRITE,
      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_TO_INVITED => WRITE,
      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_TO_AUTHOR => WRITE,
      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_RSVP_TO_INVITED => WRITE,
      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_RSVP_TO_AUTHOR => WRITE,
      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COME_TO_INVITED => WRITE,
      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COME_TO_AUTHOR => WRITE,
      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_DUE_HOME_TO_INVITED => WRITE,
      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_DUE_HOME_TO_AUTHOR => WRITE,
      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COMPLETED_TO_INVITED => WRITE,
      EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COMPLETED_TO_AUTHOR => WRITE,

      EventTypes::CLEAR_3_DAYS_DATA => WRITE,
    }
    class << self
      def read?(_mode_type)
        _mode_type.to_s.to_sym == READ
      end
      def write?(_mode_type)
        _mode_type.to_s.to_sym == WRITE
      end
      def all?(_mode_type)
        _mode_type.blank?
      end
    end
  end

  scope :by_initiator, -> (initiator) { initiator.is_a?(Parent) ? where(initiator_type: ['Parent', 'Supervisor'], initiator_id: initiator.id) : where({}) }
  scope :by_mode_type, -> (mode_type) { mode_type.blank? ? where({}) : where(mode_type: mode_type) }
  scope :by_event_type, -> (event_type) { event_type.blank? ? where({}) : where(event_type: event_type) }
  scope :by_id, -> (_id) { _id.blank? ? where({}) : where(id: _id) }

  class << self
    def createLogEvent(options)
      begin
        EventLog.create!(options)
      rescue => e
        Rails.logger.info "\n\n#{'-'*80}\n#{e.message}\n#{options.inspect}\nBacktrace: #{e.backtrace.join "\n"}\n#{'-'*80}\n\n"
        raise "#{e.message}\n#{options.inspect}\nBacktrace: #{e.backtrace.join "\n"}" 
      end
    end

    def logParentEvent(_user, _event_type, _details=nil, options={})
      unless !_user || _user.admin?
        EventLog.logEvent(_user, _event_type, _details, options)
      end
    end

    def logEvent(_user, _event_type, _details=nil, options={})
      supervisor = _user.is_a?(Parent) || _user.is_a?(Supervisor) ? _user : _user.supervisor
      EventLog.createLogEvent({
        record: options[:record],
        initiator: options[:initiator] || (supervisor || _user),
        event_type: _event_type,
        child1_id: options[:child1_id],
        child2_id: options[:child2_id],
        parent1_id: options[:parent1_id] || (supervisor ? supervisor.id : nil),
        parent2_id: options[:parent2_id],
        family1_id: options[:family1_id] || (supervisor ? supervisor.family.id : nil),
        family2_id: options[:family2_id],
        mode_type: ModeTypes::BY_EVENT_TYPE[_event_type],
        details: _details.is_a?(String) ? _details.to_s[0..MAX_STRING_INDEX] : _details.inspect.to_s[0..MAX_STRING_INDEX]
      })
    end
    handle_asynchronously :logEvent

    def clear3DaysData
      EventLog.logEvent(User.find_by_email('admin@playcelet.com'), EventTypes::CLEAR_3_DAYS_DATA, Time.now, {})
    end

    def signOutAlreadySignedInUser(_user, _details, options={})
      EventLog.logParentEvent _user, EventTypes::SIGN_OUT_ALREADY_SIGNED_IN_USER, _details, record: _user
    end

    def signIn(_user, _details=nil, options={})
      EventLog.logParentEvent _user, EventTypes::SIGN_OUT_ALREADY_SIGNED_IN_USER, _details, record: _user
    end

    def signOut(_user, _details=nil, options={})
      EventLog.logParentEvent _user, EventTypes::SIGN_OUT, _details, record: _user
    end

    def getStatus(_user, _details=nil, options={})
      EventLog.logParentEvent _user, EventTypes::GET_STATUS, _details
    end

    def getInfos(_user, _details=nil, options={})
      EventLog.logParentEvent _user, EventTypes::GET_INFOS, _details, record_type: 'Info'
    end

    def getLastInfo(_user, _id, _details=nil, options={})
      _record_id = _id.is_a?(Info) ? _id.id : _id || options[:id]
      _record = _id.is_a?(Info) ? _id : _record_id ? Info.find(_record_id) : nil
      EventLog.logParentEvent _user, EventTypes::GET_LAST_INFO, _details, record: _record
    end

    def getMessages(_user, _details=nil, options={})
      EventLog.logParentEvent _user, EventTypes::GET_MESSAGES, _details, record_type: 'Message'
    end

    def createMessage(_user, _id, _details, options={})
      _record_id = _id.is_a?(Message) ? _id.id : _id || options[:id]
      _record = _id.is_a?(Message) ? _id : _record_id ? Message.find(_record_id) : nil
      EventLog.logEvent _user, EventTypes::CREATE_MESSAGE, _details, record: _record
    end

    def getPlayNetworks(_user, _details=nil, options={})
      EventLog.logParentEvent _user, EventTypes::GET_PLAY_NETWORKS, _details, record_type: 'PlayNetwork'
    end

    def getFriends(_user, _details=nil, options={})
      EventLog.logParentEvent _user, EventTypes::GET_FRIENDS, _details, record_type: 'PlayNodes'
    end

    def getPlayInvitations(_user, _details=nil, options={})
      EventLog.logParentEvent _user, EventTypes::GET_PLAY_INVITATIONS, _details, record_type: 'PlayInvitation'
    end

    def getLastPlayInvitation(_user, _id, _details=nil, options={})
      _record_id = _id.is_a?(PlayInvitation) ? _id.id : _id || options[:id]
      _record = _id.is_a?(PlayInvitation) ? _id : _record_id ? PlayInvitation.find(_record_id) : nil
      EventLog.logParentEvent _user, EventTypes::GET_LAST_PLAY_INVITATION, _details, record: _record
    end

    def createPlayInvitation(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitation(_user, _id, EventTypes::CREATE_PLAY_INVITATION, _details, options)
    end

    def acceptPlayInvitation(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitation(_user, _id, EventTypes::ACCEPT_PLAY_INVITATION, _details, options)
    end

    def rejectPlayInvitation(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitation(_user, _id, EventTypes::REJECT_PLAY_INVITATION, _details, options)
    end

    def cancelPlayInvitation(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitation(_user, _id, EventTypes::CANCEL_PLAY_INVITATION, _details, options)
    end

    def infoSendCheckInToParent(_supervisor, _parent, _child, _details=nil, options={})
      EventLog.logParentEvent _parent.user, EventTypes::SEND_CHECK_IN_TO_PARENT, _details, {parent1_id: _parent.id, child1_id: _child.id, family1_id: _child.family_id, parent2_id: _supervisor.id, family2_id: _supervisor.family_id}
    end

    def infoSendCheckInToSupervisor(_supervisor, _child, _details=nil, options={})
      EventLog.logParentEvent _supervisor.user, EventTypes::SEND_CHECK_IN_TO_SUPERVISOR, _details, {child1_id: _child.id, family1_id: _child.family_id, parent2_id: _supervisor.id, family2_id: _supervisor.family_id}
    end

    def infoCreatePlayInvitationNotification(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION, _details, options)
    end

    def infoCreatePlayInvitationNotificationAccepted(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_ACCEPTED, _details, options)
    end

    
    def infoCreatePlayInvitationNotificationToInvited(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_TO_INVITED, _details, options)
    end

    def infoCreatePlayInvitationNotificationToAuthor(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_TO_AUTHOR, _details, options)
    end

    def infoCreatePlayInvitationNotificationRsvpToInvited(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_RSVP_TO_INVITED, _details, options)
    end

    def infoCreatePlayInvitationNotificationRsvpToAuthor(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_RSVP_TO_AUTHOR, _details, options)
    end

    def infoCreatePlayInvitationNotificationComeToInvited(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COME_TO_INVITED, _details, options)
    end

    def infoCreatePlayInvitationNotificationComeToAuthor(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COME_TO_AUTHOR, _details, options)
    end

    def infoCreatePlayInvitationNotificationDueHomeToInvited(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_DUE_HOME_TO_INVITED, _details, options)
    end

    def infoCreatePlayInvitationNotificationDueHomeToAuthor(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_DUE_HOME_TO_AUTHOR, _details, options)
    end

    def infoCreatePlayInvitationNotificationCompletedToInvited(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COMPLETED_TO_INVITED, _details, options)
    end

    def infoCreatePlayInvitationNotificationCompletedToAuthor(_user, _id, _details=nil, options={})
      EventLog.logPlayInvitationNotification(_user, _id, EventTypes::INFO_CREATE_PLAY_INVITATION_NOTIFICATION_COMPLETED_TO_AUTHOR, _details, options)
    end

    def logPlayInvitationNotification(_user, _id, _event_type, _details=nil, options={})
      _record_id = _id.is_a?(Info) ? _id.id : _id || options[:id]
      _record = _record_id ? Info.find(_record_id) : nil
      EventLog.createLogEvent({
        event_type: _event_type,
        record: _record,
        initiator: (_user.is_a?(Supervisor) || _user.is_a?(Parent) || _user.admin?) ? _user : _user.supervisor,
        child1_id: _record.child.id,
        child2_id: _record.invited_child.id,
        parent1_id: _record.app ? _record.app.supervisor.id : nil,
        parent2_id: _record.invited_child.family.parents.first.id,
        family1_id: _record.child.family.id,
        family2_id: _record.invited_child.family.id,
        mode_type: ModeTypes::BY_EVENT_TYPE[_event_type],
        details: _details.is_a?(String) ? _details : _details.inspect,
      })
    end

    def logPlayInvitation(_user, _id, _event_type, _details=nil, options={})
      _record_id = _id.is_a?(PlayInvitation) ? _id.id : _id || options[:id]
      _record = _record_id ? PlayInvitation.find(_record_id) : nil
      EventLog.createLogEvent({
        event_type: _event_type,
        record: _record,
        initiator: (_user.is_a?(Supervisor) || _user.is_a?(Parent) || _user.admin?) ? _user : _user.supervisor,
        child1_id: _record.child.id,
        child2_id: _record.invited_child.id,
        parent1_id: _record.app.supervisor.id,
        parent2_id: _record.invited_child.family.parents.first.id,
        family1_id: _record.child.family.id,
        family2_id: _record.invited_child.family.id,
        mode_type: ModeTypes::BY_EVENT_TYPE[_event_type],
        details: _details.is_a?(String) ? _details : _details.inspect,
      })
    end
    handle_asynchronously :logPlayInvitation

    def createPlayInvitationMessage(_user, _id, _details=nil, options={})
      _record_id = _id.is_a?(Message) ? _id.id : _id || options[:id]
      _record = _record_id ? Message.find(_record_id) : nil
      _event_type = EventTypes::CREATE_PLAY_INVITATION
      EventLog.createLogEvent({
        event_type: _event_type,
        record: _record,
        initiator: _user.admin? ? _user : _user.supervisor,
        child1_id: _record.child.id,
        child2_id: _record.recipient_child.id,
        parent1_id: _record.app.supervisor.id,
        parent2_id: _record.recipient_child.family.parents.first.id,
        family1_id: _record.child.family.id,
        family2_id: _record.recipient_child.family.id,
        mode_type: ModeTypes::BY_EVENT_TYPE[_event_type],
        details: _details.is_a?(String) ? _details : _details.inspect,
      })
    end

    def createCheckInMessage(_user, _id, _details=nil, options={})
      _record_id = _id.is_a?(Message) ? _id.id : _id || options[:id]
      _record = _record_id ? Message.find(_record_id) : nil
      _event_type = EventTypes::CREATE_MESSAGE_CHECK_IN
      EventLog.createLogEvent({
        event_type: _event_type,
        record: _record,
        initiator: _user.admin? ? _user : _user.supervisor,
        child1_id: _record.child.id,
        parent1_id: _record.child.family.parents.first.id,
        parent2_id: _record.app.supervisor.id,
        family1_id: _record.child.family.id,
        family2_id: _record.app.supervisor.family.id,
        mode_type: ModeTypes::BY_EVENT_TYPE[_event_type],
        details: _details.is_a?(String) ? _details : _details.inspect,
      })
    end

    def childCheckIn(_child, _parent, _details=nil, options={})
      EventLog.logChildCheckIn(_child, _parent, EventTypes::CHILD_CHECK_IN, _details, options)
    end

    def logChildCheckIn(_child, _parent, _event_type, _details=nil, options={})
      EventLog.createLogEvent({
        event_type: _event_type,
        child1_id: _child.id,
        parent1_id: _parent.id,
        family1_id: _child.family.id,
        family2_id: _parent.family.id,
        mode_type: ModeTypes::BY_EVENT_TYPE[_event_type],
        details: _details.is_a?(String) ? _details : _details.inspect,
      })
    end
    handle_asynchronously :logChildCheckIn

    def createCheckOutMessage(_user, _id, _details=nil, options={})
      EventLog.logChildCheckOut(_child, _parent, EventTypes::CHILD_AUTO_CHECK_OUT, _details, options)
    end

    def childCheckOut(_child, _parent, _details=nil, options={})
      EventLog.logChildCheckOut(_child, _parent, EventTypes::CHILD_CHECK_OUT, _details, options)
    end

    def infoChildIsOutOfContact(_child, _parent, _details=nil, options={})
      EventLog.logChildCheckOut(_child, _parent, EventTypes::CHILD_IS_OUT_OF_CONTACT, _details, options)
    end

    def logChildCheckOut(_child, _parent, _event_type, _details=nil, options={})
      EventLog.createLogEvent({
        event_type: _event_type,
        child1_id: _child.id,
        parent1_id: _parent.id,
        family1_id: _child.family.id,
        family2_id: _parent.family.id,
        mode_type: ModeTypes::BY_EVENT_TYPE[_event_type],
        details: _details.is_a?(String) ? _details : _details.inspect,
      })
    end
    handle_asynchronously :logChildCheckOut

    def createComeHomeMessage(_user, _id, _details=nil, options={})
      logComeHomeMessage(_user, _id, EventTypes::CREATE_MESSAGE, 'message_type:COME_HOME', options)
    end

    def logComeHomeMessage(_user, _id, _event_type, _details=nil, options={})
      _record_id = _id.is_a?(Message) ? _id.id : _id || options[:id]
      _record = _id.is_a?(Message) ? _id : _record_id ? Message.find(_record_id) : nil
      EventLog.createLogEvent({
        event_type: _event_type,
        child1_id: _record.recipient_child.id,
        parent1_id: _record.app.supervisor.id,
        family1_id: _record.recipient_child.family.id,
        mode_type: ModeTypes::BY_EVENT_TYPE[_event_type],
        details: _details.is_a?(String) ? _details : _details.inspect,
      })
    end
    handle_asynchronously :logComeHomeMessage

    def createChild(_user, _id, _details=nil, options={})
      _record_id = _id.is_a?(Child) ? _id.id : _id || options[:id]
      _record = _id.is_a?(Child) ? _id : _record_id ? Child.find(_record_id) : nil
      EventLog.logEvent _user, EventTypes::CREATE_CHILD, _details, record: _record, family1_id: (_record ? _record.family_id : nil), parent1_id: (_user.parent? && _user.supervisor ? _user.supervisor.id : nil)
    end

    def updateChild(_user, _id, _details=nil, options={})
      _record_id = _id.is_a?(Child) ? _id.id : _id || options[:id]
      _record = _id.is_a?(Child) ? _id : _record_id ? Child.find(_record_id) : nil
      EventLog.logEvent _user, EventTypes::UPDATE_CHILD, _details, record: _record, family1_id: (_record ? _record.family_id : nil), parent1_id: (_user.parent? && _user.supervisor ? _user.supervisor.id : nil)
    end

    def destroyChild(_user, _id, _details=nil, options={})
      _record_id = _id.is_a?(Child) ? _id.id : _id || options[:id]
      _record = _id.is_a?(Child) ? _id : _record_id ? Child.find(_record_id) : nil
      EventLog.logEvent _user, EventTypes::DESTROY_CHILD, "#{_details}\nchild_id: #{_id}", record: _record, family1_id: (_record ? _record.family_id : nil), parent1_id: (_user.parent? && _user.supervisor ? _user.supervisor.id : nil)
    end
  end
end
