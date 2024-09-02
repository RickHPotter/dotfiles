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

      # In Ubuntu 24.04, the package libaio1 was renamed to libaio1t64 and so on.
      unless `lsb_release -a | grep "Ubuntu 24`.empty?
        cd("~/Downloads") do
          download("http://launchpadlibrarian.net/648013231/libtinfo5_6.4-2_amd64.deb")
          download("http://launchpadlibrarian.net/648013227/libncurses5_6.4-2_amd64.deb")
          download("http://launchpadlibrarian.net/646633572/libaio1_0.3.113-4_amd64.deb")

          bash("sudo dpgk -i ./libtinfo5_6.4-2_amd64.deb")
          bash("sudo dpgk -i ./libncurses5_6.4-2_amd64.deb")
          bash("sudo dpgk -i ./libaio1_0.3.113-4_amd64.deb")
        end
      end

      puts "Oracle was successfully installed.".end
    end
  end
end
