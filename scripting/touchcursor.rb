# frozen_string_literal: true

require "fileutils"

module Scripting
  class Touchcursor < Scripting::Util
    attr_reader :source_folder, :repo_url, :repo_dir

    def initialize
      @source_folder = "~/.config/touchcursor"
      @repo_url = "donniebreve/touchcursor-linux.git"
      @repo_dir = "/tmp/touchcursor-linux"
      super
    end

    def run
      puts "Installing and setting up Touchcursor...".start

      install_touchcursor
      copy_config_file
      restart_service

      puts "Touchcursor was successfuly installed and configured".end
    end

    protected

    def install_touchcursor
      rm_rf(repo_dir)

      git_clone(repo_url, repo_dir)
      cd(repo_dir) do
        bash("make")
        bash("make install")
      end

      rm_rf(repo_dir)
    end

    def copy_config_file
      mkdir_p(source_folder)
      cp(File.join(config_files_dir, "touchcursor.conf"), source_folder)
    end

    def restart_service
      bash("systemctl --user restart touchcursor.service")
    end
  end
end
