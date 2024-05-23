# frozen_string_literal: true

require "fileutils"

module Scripting
  class Touchcursor < Scripting::Util
    def self.run
      new.run
    end

    def run
      remove_previous_installation
      install_touchcursor
      copy_config_file
      restart_service
    end

    protected

    def remove_previous_installation
      bash("sudo systemctl stop touchcursor.service")
      bash("sudo systemctl disable touchcursor.service")
      bash("sudo rm /etc/systemd/system/touchcursor.service")
      bash("sudo rm -r /etc/touchcursor")
    end

    def install_touchcursor
      repo_url = "https://github.com/donniebreve/touchcursor-linux.git"

      git_clone(repo_url, "/tmp/touchcursor-linux")
      cd(repo_dir) { bash("make && sudo make install") }
      rm_rf(repo_dir)
    end

    def copy_config_file
      config_dir = "~/.config/touchcursor"

      mkdir_p(config_dir)
      cp("config/touchcursor.conf", config_dir)
    end

    def restart_service
      bash("systemctl --user restart touchcursor.service")
    end
  end
end
