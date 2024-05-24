# frozen_string_literal: true

require "fileutils"

module Scripting
  class Touchcursor < Scripting::Util
    def self.run
      new.run
    end

    def run
      install_touchcursor
      copy_config_file
      restart_service
    end

    protected

    def install_touchcursor
      repo_url = "donniebreve/touchcursor-linux.git"
      repo_dir = "/tmp/touchcursor-linux"

      rm_rf(repo_dir)

      git_clone(repo_url, repo_dir)
      cd(repo_dir) do
        bash("make")
        bash("make install")
      end

      rm_rf(repo_dir)
    end

    def copy_config_file
      config_file = File.join(config_files_dir, "touchcursor.conf")
      source_folder = "~/.config/touchcursor"

      mkdir_p(source_folder)
      cp(config_file, source_folder)
    end

    def restart_service
      bash("systemctl --user restart touchcursor.service")

      p "Touchcursor was successfuly installed"
    end
  end
end
