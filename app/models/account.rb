class Account < ActiveRecord::Base
  validates :name, :presence => true
  validates :domain, :format => { :with => /^[a-z0-9]{1,15}$/ }, :uniqueness => true, :exclusion => { :in => %w(www smtp ftp ssh mail app pop resque) }
  cattr_accessor :current
  attr_accessible :name, :domain, :first_user_params, :coupon, :goal_quantitative, :goal_qualitative
  scope :active, where(:active => true)
  scope :inactive, where(:active => false).where("created_at < ?", 1.month.ago)

  class << self
    def find_current
      Account.current = Account.first
    end

    def configure_by_domain(domain)
      Account.current = find_by_domain!(domain)
      Account.current if Rails.env.production?
      Account.current
    end

    def destroy_inactive
      Account.inactive.each do |account|
        account.destroy
      end
    end

    def activate(id)
      find(id).update_attribute(:active, true)
    end

    def deactivate(id, kind)
      account = find(id)
      account.update_attribute(:active, false)
      account if Rails.env.production?
      if kind == :disable
        UserMailer.your_account_was_disabled(account.admin_user).deliver
      elsif kind == :lock
        UserMailer.your_account_was_locked(account.admin_user).deliver
      end
    end
  end

  def admin_name
    admin_user.name
  end

  def admin_email
    admin_user.email
  end

  def create_user(user_params)
    user = User.new(user_params)
    user.admin = true
    user.save!
    true
  end

  def admin_user
    @admin_user ||= User.where(:admin => true).first
  end
end
