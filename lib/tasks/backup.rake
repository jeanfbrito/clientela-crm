namespace :backup do
  task :run do
    begin
      Rake::Task['backup:databases'].invoke
      Rake::Task['backup:files'].invoke
    rescue => e
      HoptoadNotifier.notify e
    end
  end
  
  task :files do
    system %{ssh #{backup_server} "mkdir -p #{remote_backup_dir}"}
    system %{rsync -a --delete-excluded #{local_shared_path}/ #{backup_server}:#{remote_backup_dir}}
  end
  
  def backup_server
    "67.23.239.112"
  end
  
  def local_shared_path
    "/home/railsapps/clientela/shared"
  end
  
  def remote_backup_dir
    "/home/railsapps/backups"
  end
  
  task :databases => :environment do
    options = "--single-transaction --flush-logs --add-drop-table --add-locks --create-options --disable-keys --extended-insert --quick -u root"    
    system "mysqldump #{options} clientela_production | gzip > #{backup_app_filename}"
    Account.all.each { |account| system "mysqldump #{options} #{database(account)} | gzip > #{backup_filename(account)}" }
  end
  
  def database(account)
    "app_#{account.domain}"
  end
  
  def backup_app_filename
    File.join(backup_dir, "clientela_production.#{timestamp}.sql.gz")
  end
  
  def backup_filename(account)
    File.join(backup_dir, "#{database(account)}.#{timestamp}.sql.gz")
  end
  
  def backup_dir
    dir = "/home/railsapps/clientela/shared/db"
    FileUtils.mkdir_p(dir)
    dir
  end
  
  def timestamp
    Time.now.strftime("%Y%m%d%H%M%S")
  end
end

namespace :restore do
  task :databases => :environment do
    system "gunzip < #{r_latest_backup_app_filename} | mysql -u root clientela_production"
    Account.all.each do |account|
      account.create_database(false)
      system "gunzip < #{r_latest_backup_filename(account)} | mysql -u root #{database(account)}"
    end
  end
  
  def r_latest_backup_app_filename
    Dir.glob(r_backup_app_filename).sort.last
  end
  
  def r_latest_backup_filename(account)
    Dir.glob(r_backup_filename(account)).sort.last
  end
  
  def r_backup_app_filename
    File.join(r_backup_dir, "clientela_production.*.sql.gz")
  end
  
  def r_backup_filename(account)
    File.join(backup_dir, "#{database(account)}.*.sql.gz")
  end
  
  def r_backup_dir
    "/home/railsapps/clientela/shared/db"
  end
end