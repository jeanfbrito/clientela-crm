class AddCouponAndFreeUntilToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :coupon, :string
    add_column :accounts, :free_until, :datetime
    execute("UPDATE accounts SET free_until = '2011-05-31 23:59:59'")
  end

  def self.down
    remove_column :accounts, :coupon
    remove_column :accounts, :free_until
  end
end
