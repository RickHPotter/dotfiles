# frozen_string_literal: true

require_relative "util"

module Scripting
  class Oracle < Scripting::Util
    def self.run
      new.run
    end

    def run
      mkdir_p("/opt/oracle")
      cd("/opt/oracle") do
        download("https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-basic-linux.x64-21.12.0.0.0dbru.zip")
        download("https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-sdk-linux.x64-21.12.0.0.0dbru.zip")
        bash("sudo unzip instantclient-basic-linux.x64-21.12.0.0.0dbru.zip")
        bash("sudo unzip instantclient-sdk-linux.x64-21.12.0.0.0dbru.zip")
      end
    end
  end
end
