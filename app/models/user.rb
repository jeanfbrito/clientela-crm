class User < ActiveRecord::Base
  has_many :activities, :foreign_key => :author_id, :dependent => :nullify
  has_many :tasks, :foreign_key => :assigned_to_id, :dependent => :destroy
  has_many :deals, :foreign_key => :assigned_to_id, :dependent => :nullify
  has_and_belongs_to_many :groups

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :invitable
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :time_zone
  validates :name, :presence => true
  before_save :ensure_authentication_token
  before_create :reset_dropbox_token
  after_create :create_individual_group
  after_invitation_accepted :create_individual_group
  serialize :survey
  scope :active, where(:invitation_token => nil).order(:name)

  class << self
    def notifiable_we_are_missing_you_users
      where(["(current_sign_in_at is NULL OR current_sign_in_at < ?) AND created_at < ?", 2.weeks.ago, 2.weeks.ago]).select { |u| !u.survey[:we_are_missing_you_notified] }
    end

    def notify_we_are_missing_you
      Account.active.each do |account|
        account.configure!

        notifiable_we_are_missing_you_users.each do |user|
          UserMailer.we_are_missing_you(user).deliver
          user.update_survey(:we_are_missing_you_notified => true)
        end
      end
    end

    def notifiable_satisfaction_survey_users
      where(["created_at < ?", 1.weeks.ago]).select { |u| !u.survey[:satisfaction_survey] }
    end

    def notify_satisfaction_survey
      Account.active.each do |account|
        account.configure!
        
        notifiable_satisfaction_survey_users.each do |user|
          UserMailer.satisfaction_survey_first_week(user,account).deliver
          user.update_survey(:satisfaction_survey => true)
        end
      end
    end
  end

  def update_attributes_with_password_ignore(params={})
    params.delete(:password) if params[:password].blank?
    params.delete(:password_confirmation) if params[:password_confirmation].blank?

    result = update_attributes_without_password_ignore(params)
    clean_up_passwords
    result
  end
  alias_method_chain :update_attributes, :password_ignore

  def survey
    self[:survey].blank? ? {} : self[:survey]
  end

  def update_survey(new_values)
    survey_to_update = (self.survey || {})
    update_attribute(:survey, survey_to_update.merge(new_values))
  end

  def active_for_authentication?
    super && (Account.current ? Account.current.active? : true)
  end

  def to_xml(options = {}, &block)
    super(options.merge(:except => [:encrypted_password, :remember_token, :reset_password_token, :welcome]), &block)
  end

  def reset_dropbox_token
    self.dropbox_token = ActiveSupport::SecureRandom.hex(3)
  end

  def reset_dropbox_token!
    reset_dropbox_token
    self.save(:validate => false)
  end

  def create_individual_group
    self.groups.create(:name => self.name, :individual => true) unless self.name.blank?
  end
end
