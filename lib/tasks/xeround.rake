namespace :vps do
  def run(*cmd)
    system(*cmd)
    raise "Command #{cmd.inspect} failed!" unless $?.success?
  end

  namespace :db do
    def dump_options
      "--single-transaction --flush-logs --add-drop-table --add-locks --create-options --disable-keys --extended-insert --quick"
    end

    def connection_options
      "-h 127.0.0.1 -u root -P 3307"
    end

    def timestamp
      @timestamp ||= Time.now.strftime("%Y%m%d%H%M%S")
    end

    def backup_dir
      "backups/#{timestamp}"
    end

    task :app_backup do
      puts "-----> Backuping application db..."
      run "mkdir -p #{backup_dir}"
      run "mysqldump #{dump_options} #{connection_options} clientela_production > #{backup_dir}/clientela_production.sql"
      puts "-----> Finished!"
    end

    task :clients_backup => :environment do
      puts "-----> Backuping clients db..."
      run "mkdir -p #{backup_dir}"
      Account.establish_connection('vps')
      Account.all.each do |account|
        print '.'
        STDOUT.flush
        account.create_database(false)
        run "mysqldump #{dump_options} #{connection_options} app_#{account.domain} > #{backup_dir}/app_#{account.domain}.sql"
      end
      puts "\n-----> Finished!"
    end

    # ssh -L 3307:localhost:3306 -N railsapps@184.106.92.185
    task :backup => [:app_backup, :clients_backup]
  end
end
namespace :xeround do
  def run(*cmd)
    system(*cmd)
    raise "Command #{cmd.inspect} failed!" unless $?.success?
  end

  namespace :db do
    def connection_options
      "-h instance11994.db.xeround.com -u app4192886 -pacSuKeRJ -P 8145"
    end

    def backup_dir
      Dir['backups/*'].last
    end

    def xeround_create_database(database)
      puts "-----> Creating #{database} db..."
      begin
        ActiveRecord::Base.connection.drop_database(database)
      rescue
        nil
      ensure
        ActiveRecord::Base.connection.create_database(database, {:charset => 'utf8', :collation => 'utf8_unicode_ci'})
      end
    end

    def establish_connection!
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['xeround'])
    end

    task :restore_app do
      establish_connection!
      xeround_create_database('clientela_production')
      puts "-----> Restoring application db..."
      run "mysql #{connection_options} clientela_production < #{backup_dir}/clientela_production.sql"
    end

    task :restore_clients do
      establish_connection!
      Dir["#{backup_dir}/app_*.sql"].each do |filename|
        database = filename.match(/backups\/.*\/(app_.*)\.sql/)[1]
        next unless database == "app_helabs" # Remove

        xeround_create_database(database)
        puts "-----> Restoring #{database} db..."
        run "mysql #{connection_options} #{database} < #{filename}"
      end
    end

    task :restore => [:environment, :restore_clients]
  end
end
