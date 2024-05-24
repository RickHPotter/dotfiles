# frozen_string_literal: true

require "fileutils"
require "open3"

module Scripting
  class Util
    attr_accessor :current_user, :assets_dir, :config_files_dir

    def initialize
      @current_user = ENV["user"]
      current_dir = File.expand_path(__FILE__)
      current_folder = File.dirname(current_dir)
      root_dir = File.dirname(current_folder)

      @assets_dir = File.join(root_dir, "assets")
      @config_files_dir = File.join(root_dir, "config_files")
    end

    def bash(command)
      p "Running: #{command}"
      stdout, stderr, status = Open3.capture3(command)

      unless status.success?
        p "Error: #{stderr}"
        exit 1
      end

      p stdout
    end

    def bashs(*commands)
      return if commands.empty?

      commands.each do |command|
        bash(command)
      end
    end

    def git_clone(repo, path = "")
      bash("git clone https://github.com/#{repo} #{path}")
    end

    def download(url, location = "", sudo: false)
      args = "-LO"
      args = "-Lo #{location}" if location != ""

      bash("#{'sudo' if sudo} curl #{args} \"#{url}\"")
    end

    def mkdir_p(path, sudo: false)
      path = File.expand_path(path)
      return bash("sudo mkdir -p #{path}") if sudo

      FileUtils.mkdir(path) unless File.exist?(path)
    end

    def cd(path, &block)
      Dir.chdir(File.expand_path(path), &block)
    end

    def rm_rf(path, sudo: false)
      return bash("sudo rm -rf #{path}") if sudo

      FileUtils.rm_rf(File.expand_path(path))
    end

    def cp(content, destination_path, sudo: false)
      return bash("sudo cp -r #{content} #{destination_path}") if sudo

      FileUtils.cp(File.expand_path(content), File.expand_path(destination_path))
    end

    def mv(source_path, destination_path, sudo: false)
      return bash("sudo mv #{source_path} #{destination_path}") if sudo

      FileUtils.mv(File.expand_path(source_path), File.expand_path(destination_path))
    end
  end
end
