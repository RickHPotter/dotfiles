# frozen_string_literal: true

require_relative "util"

module Scripting
  class Oracle < Scripting::Util
    attr_reader :source_folder

    def initialize
      @source_folder = "/opt/oracle"
      super
    end

    def run
      puts "Installing Oracle...".start

      rm_rf(source_folder, sudo: true)
      mkdir_p(source_folder, sudo: true)

      cd(source_folder) do
        download("https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-basic-linux.x64-21.12.0.0.0dbru.zip", sudo: true)
        download("https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-sdk-linux.x64-21.12.0.0.0dbru.zip", sudo: true)
        bash("sudo unzip -qq instantclient-basic-linux.x64-21.12.0.0.0dbru.zip")
        bash("sudo unzip -qq instantclient-sdk-linux.x64-21.12.0.0.0dbru.zip")
      end

      puts "Oracle was successfully installed.".end
    end
  end
end
