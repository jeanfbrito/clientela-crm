namespace :db do
  namespace :migrate do
    task :accounts => :environment do
      Account.migrate
    end
  end
end