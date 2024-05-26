# frozen_string_literal: true

require "open3"
require "tempfile"
require_relative "util"

module Scripting
  class Postgresql < Scripting::Util
    attr_reader :pg_user, :pg_password, :pg_hba_conf, :pg_hba_conf_backup

    def initialize
      @pg_user     = "postgres"
      @pg_password = "postgres"
      @pg_hba_conf = File.expand_path("/etc/postgresql/12/main/pg_hba.conf")
      @pg_hba_conf_backup = File.expand_path("#{pg_hba_conf}.bak")
      super
    end

    def run
      puts "Installing PostgreSQL and creating postgres user with password postgres...".end

      install_postgres
      create_postgres_user
      allow_password_authentication

      puts "PostgreSQL was successfully installed and configured.".end
    end

    protected

    def install_postgres
      bash("sudo apt-get update -qq")
      bash("sudo apt-get install -qq postgresql postgresql-contrib")
      bash("sudo service postgresql start")
    end

    def create_postgres_user
      user_exists_command = %(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='#{pg_user}'")
      stdout, stderr, status = Open3.capture3(user_exists_command)
      raise "Error: #{stderr}" if stderr.strip != ""

      if status.success? && stdout.strip == "1"
        update_user_command = %(sudo -u postgres psql -c "ALTER USER #{pg_user} WITH PASSWORD '#{pg_password}';")
        bash(update_user_command)
      else
        create_user_command = %(sudo -u postgres psql -c "CREATE USER #{pg_user} WITH PASSWORD '#{pg_password}';")
        bash(create_user_command)
      end

      grant_privileges_command = %(sudo -u postgres psql -c "ALTER USER #{pg_user} CREATEDB;")
      bash(grant_privileges_command)
    end

    def allow_password_authentication
      bash("sudo cp #{pg_hba_conf} #{pg_hba_conf_backup}")

      current_user = `whoami`.strip
      bash("sudo chown #{current_user} #{pg_hba_conf}")

      File.open(pg_hba_conf, "a") do |f|
        f.puts "local   all             postgres                                peer"
      end

      bash("sudo chown postgres #{pg_hba_conf}")

      bash("sudo service postgresql restart")
    end
  end
end
