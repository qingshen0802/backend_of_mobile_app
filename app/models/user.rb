class User < ActiveRecord::Base
  acts_as_token_authenticatable
  has_one :supervisor
  has_one :app, through: :supervisor

  module Roles
  	ADMIN = 'admin'
    PARENT = 'parent'
    SUPERVISOR = 'supervisor'
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :supervisor
  has_one :family, through: :supervisor
  has_many :children, through: :family
  before_validation :set_default_role
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /@/
  validates :role, presence: true

  scope :supervisors_and_parents, -> { where(role: [Roles::PARENT, Roles::SUPERVISOR])}

  def set_default_role
    self.role ||= Roles::PARENT
  end

  def parent
    supervisor
  end

  def admin?
  	role == Roles::ADMIN
  end

  def parent?
    role == Roles::PARENT
  end

  def supervisor?
    role == Roles::SUPERVISOR
  end

  def supervisor_or_parent?
    [Roles::SUPERVISOR, Roles::PARENT].include? role
  end

  def to_s
    email
  end

  def as_json(options = {})
    { email: email, authentication_token: authentication_token }
  end
end
