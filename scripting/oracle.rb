# frozen_string_literal: true

require_relative "util"

module Scripting
  class Oracle < Scripting::Util
    def self.run
      new.run
    end

    def run
      rm_rf("/opt/oracle", sudo: true)

      mkdir_p("/opt/oracle", sudo: true)

      cd("/opt/oracle") do
        download("https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-basic-linux.x64-21.12.0.0.0dbru.zip", sudo: true)
        download("https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-sdk-linux.x64-21.12.0.0.0dbru.zip", sudo: true)
        bash("sudo unzip instantclient-basic-linux.x64-21.12.0.0.0dbru.zip")
        bash("sudo unzip instantclient-sdk-linux.x64-21.12.0.0.0dbru.zip")
      end

      p "Go was successfully installed."
    end
  end
end
