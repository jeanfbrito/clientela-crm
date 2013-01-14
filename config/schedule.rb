# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

env :PATH, "/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games"
env :RAILS_ENV, "production"
job_type :command, "cd :path && :task :output"
set :job_template, nil
set :output, "/home/railsapps/clientela/shared/log/whenever.log"

every :hour do
  rake "backup:run"
end

every 1.minute do
  command "script/mailman"
end

every 10.minutes do
  rake "whenever:notify_users"
end

every 5.minutes do
  command "rake thinking_sphinx:index INDEX_ONLY=true"
end

every 1.day, :at => '12:00 pm' do
  rake "whenever:notify_we_are_missing_you"
end

every 1.day, :at => '13:00 pm' do
  rake "whenever:notify_satisfaction_survey"
end

every 1.day, :at => '4:00 am' do
  rake "whenever:destroy_inactive_accounts"
end

# every "0 10 1 * *" do
#   rake "whenever:run_billing_for_current_month"
# end