namespace :whenever do
  task :destroy_inactive_accounts => :environment do
    begin
      Account.destroy_inactive
    rescue => e
      HoptoadNotifier.notify e
    end
  end

  task :notify_we_are_missing_you => :environment do
    begin
      User.notify_we_are_missing_you
    rescue => e
      HoptoadNotifier.notify e
    end
  end

  task :notify_satisfaction_survey => :environment do
    begin
      User.notify_satisfaction_survey
    rescue => e
      HoptoadNotifier.notify e
    end
  end

  task :notify_users => :environment do
    begin
      Task.notify_users
    rescue => e
      HoptoadNotifier.notify e
    end
  end

  task :run_billing_for_current_month => :environment do
    begin
      Account.run_billing_for_current_month
    rescue => e
      HoptoadNotifier.notify e
    end
  end
end
