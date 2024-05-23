# frozen_string_literal: true

require 'open3'
require_relative 'scripting/util'

module Scripting
  class Postgresql < Scripting::Util # :nodoc:
    def run
      # Install PostgreSQL
      bash('sudo apt-get update')
      bash('sudo apt-get install -y postgresql postgresql-contrib')

      # Initialize PostgreSQL
      bash('sudo service postgresql start')

      # Create PostgreSQL User
      pg_user = 'myuser'
      pg_password = 'mypassword'
      pg_db = 'mydatabase'

      # Check if the user already exists
      user_exists_command = %(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='#{pg_user}'")
      stdout, _stderr, status = Open3.capture3(user_exists_command)
      if status.success? && stdout.strip == '1'
        puts "User #{pg_user} already exists"
      else
        create_user_command = %(sudo -u postgres psql -c "CREATE USER #{pg_user} WITH PASSWORD '#{pg_password}';")
        bash(create_user_command)

        # Grant privileges to the user
        grant_privileges_command = %(sudo -u postgres psql -c "ALTER USER #{pg_user} CREATEDB;")
        bash(grant_privileges_command)
      end

      # Create PostgreSQL Database
      db_exists_command = %(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='#{pg_db}'")
      stdout, _stderr, status = Open3.capture3(db_exists_command)
      if status.success? && stdout.strip == '1'
        puts "Database #{pg_db} already exists"
      else
        create_db_command = %(sudo -u postgres createdb -O #{pg_user} #{pg_db})
        bash(create_db_command)
      end

      # Modify pg_hba.conf to allow password authentication
      pg_hba_conf = '/etc/postgresql/12/main/pg_hba.conf'
      pg_hba_conf_backup = "#{pg_hba_conf}.bak"
      bash("sudo cp #{pg_hba_conf} #{pg_hba_conf_backup}") # Backup the original pg_hba.conf

      File.open(pg_hba_conf, 'a') do |file|
        file.puts 'host    all             all             127.0.0.1/32            md5'
        file.puts 'host    all             all             ::1/128                 md5'
      end

      # Restart PostgreSQL to apply changes
      bash('sudo service postgresql restart')

      puts 'PostgreSQL installation and configuration completed successfully.'
      puts "Database '#{pg_db}' created with user '#{pg_user}'."
    end
  end
end
