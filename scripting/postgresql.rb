# frozen_string_literal: true

require "open3"
require "tempfile"
require_relative "util"

module Scripting
  class Postgresql < Scripting::Util
    def self.run
      new.run
    end

    def run
      install_postgres
      create_postgres_user
      allow_password_authentication

      p "PostgreSQL was successfully installed."
    end

    def install_postgres
      bash("sudo apt-get update -qq")
      bash("sudo apt-get install -qq postgresql postgresql-contrib")
      bash("sudo service postgresql start")
    end

    def create_postgres_user
      pg_user     = "postgres"
      pg_password = "postgres"

      user_exists_command = %(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='#{pg_user}'")
      stdout, _stderr, status = Open3.capture3(user_exists_command)

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
      pg_hba_conf = File.expand_path("/etc/postgresql/12/main/pg_hba.conf")
      pg_hba_conf_backup = File.expand_path("#{pg_hba_conf}.bak")
      bash("sudo cp #{pg_hba_conf} #{pg_hba_conf_backup}")

      existing_content = `sudo cat #{pg_hba_conf}`

      Tempfile.open("pg_hba_conf") do |tempfile|
        tempfile.p existing_content
        tempfile.p "host    all             all             127.0.0.1/32            md5"
        tempfile.p "host    all             all             ::1/128                 md5"
        tempfile.flush

        mv(tempfile.path, "pg_hba_conf", sudo: true)
        tempfile.unlink
      end

      bash("sudo service postgresql restart")
    end
  end
end
