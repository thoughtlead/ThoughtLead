namespace :db do
  def db_info
    raise 'RAILS_ENV needs to be set for the database you are trying to backup.' unless RAILS_ENV
    @db_info ||= YAML.load_file("#{RAILS_ROOT}/config/database.yml")[RAILS_ENV]
  end
  
  desc "Backup the database to (optional environment variable with default value) SNAPSHOT_FILE"
  task :backup do
    filename = ENV['SNAPSHOT_FILE'] || "#{RAILS_ROOT}/db/#{RAILS_ENV}_snapshot-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}"
    
    case db_info['adapter']
      when "mysql"
        puts "snapshotting data to #{filename}.mysql"
        sh "mysqldump -u #{db_info['username']} --password=#{db_info['password']} -h #{db_info['host'] || 'localhost'} #{db_info['database']} > #{filename}.mysql"
      when "sqlite3"
        puts "snapshotting data to #{filename}.sqlite"
        sh "cp #{RAILS_ROOT}/#{db_info['db_file']} #{filename}.sqlite"
      when nil
        raise "Could not read your database.yml file."
    else # case
      raise "Unsupported database config. Please update the db:snapshot task to include behavior for #{db_info['adapter']}"
    end # case
  end # task :snapshot
  
  desc "Restore the snapshot SNAPSHOT_FILE"
  task :restore do
    filename = ENV['SNAPSHOT_FILE']
    raise "Please specify a file to restore with the SNAPSHOT_FILE=<filename> argument." unless filename
    
    case db_info['adapter']
      when "mysql"
        puts "restoring data from #{filename}"
        sh "mysqldump -u #{db_info['username']} --password=#{db_info['password']} -h #{db_info['host'] || 'localhost'} #{db_info['database']} > #{filename}.mysql"
        # clear the DB incase it is in an inconsistant state (i.e. between migrations)
        sh "echo DROP DATABASE thoughtlead_development; CREATE DATABASE thoughtlead_development | mysql -u #{db_info['username']} --password=#{db_info['password']} -h #{db_info['host'] || 'localhost'} #{db_info['database']}"
        sh "mysql -u #{db_info['username']} --password=#{db_info['password']} -h #{db_info['host'] || 'localhost'} #{db_info['database']} < #{filename}"        
      when nil
        raise "Could not read your database.yml file."
    else # case
      raise "Unsupported database config. Please update the db:snapshot task to include behavior for #{db_info['adapter']}"
    end # case
    # TODO ensure the file is the same format as the database we're using.
    # TODO everything else.
  end
  
end # namespace
