class Supervisor < ActiveRecord::Base
  belongs_to :family
  belongs_to :app
  belongs_to :user
  has_many :children, through: :family
  has_many :infos, through: :app

  before_validation :create_app
  before_validation :validate_user
  before_save :save_user
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :family, presence: true
  validates :app, presence: true
  validates :user, presence: true

  scope :supervisors, -> { where(type: 'Supervisor')}
  attr_accessor :user_valid, :user_saved

  def infos_by_type(message_types)
    if message_types.blank?
      message_types = nil
    elsif message_types.is_a?(String)
      message_types = [message_types]
    end
    info_relation = if message_types && message_types.any?{|message_type| message_type == Message::MessageTypes::LIGHT}
      Info.where(infos_for_children.or(Info.by_app_id(self.app_id).where_values.reduce(:and)).to_sql)
    else
      infos
    end
    info_relation.by_message_type(message_types)
  end

  def infos_for_children
    c_ids = family.children.map(&:id) + Child.by_app_id(app_id).map(&:id)

    Info.by_recipient_child_id(c_ids).where_values.reduce(:and)
  end

  def ensure_user
    unless @user_valid || self.user
      unless @user
        @user = User.new
      end
      self.user = @user
    end
    @user ||= self.user
  end

  def user_email
    ensure_user.email
  end

  def user_email=(_email)
    ensure_user.email = _email
  end

  def user_password
    self.password
  end

  def user_password=(_password)
    self.password = _password
    ensure_user.password = _password unless _password.blank?
  end

  def user_password_confirmation
    ensure_user.password_confirmation
  end

  def user_password_confirmation=(_password_confirmation)
    ensure_user.password_confirmation = _password_confirmation unless _password_confirmation.blank?
  end

  def validate_user
    unless @user_valid
      @user_valid ||= ensure_user.valid?
      unless @user_valid
        ensure_user.errors.full_messages.each do |error_message|
          self.errors.add(:base, error_message)
        end
      end
    end
    @user_valid
  end

  def save_user
    unless @user_saved
      @user_saved = @user_valid
      @user.save if @user_valid
    end
  end

  def create_app
    unless self.app
      self.app = App.create_android_app
    end
    self.app
  end

  def can_receive_info_about?(child)
    true
  end

  def place
    family
  end

  def name
  	[first_name, last_name].join(' ')
  end

  def to_s
    name
  end

  def as_json(options = {})
    {
      id: id,
      name: name,
      first_name: first_name,
      last_name: last_name,
    }
  end
end
