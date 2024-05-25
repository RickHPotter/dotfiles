# frozen_string_literal: true

require "fileutils"
require "open3"

module Scripting
  class Util
    attr_reader :assets_dir, :config_files_dir

    def self.run
      new.run
    rescue NotImplementedError
      puts "Error: Run Method not implemented.".error
    end

    def initialize
      current_dir = File.expand_path(__FILE__)
      current_folder = File.dirname(current_dir)
      root_dir = File.dirname(current_folder)

      @assets_dir = File.join(root_dir, "assets")
      @config_files_dir = File.join(root_dir, "config_files")
    end

    def bash(command)
      puts "`#{command[0..116]}#{command.length > 117 ? '...' : ''}`".info1

      _stdout, stderr, status = Open3.capture3(command)

      return if status.success?

      puts "Error: #{stderr}".error
      exit 1
    end

    def bashs(*commands)
      return if commands.empty?

      commands.each do |command|
        bash(command)
      end
    end

    def git_clone(repo, path = "")
      bash("git clone --q https://github.com/#{repo} #{path}")
    end

    def download(url, location = nil, sudo: false)
      commands = [
        sudo ? "sudo" : "",
        "curl -L",
        location ? "-o #{location}" : "-O",
        "\"#{url}\"",
        "-s"
      ]

      bash(commands.join(" "))
    end

    def mkdir_p(path, sudo: false)
      commands = [
        sudo ? "sudo" : "",
        "mkdir -p",
        File.expand_path(path)
      ]

      bash(commands.join(" "))
    end

    def cd(path, &)
      puts "cd into #{path}".info2
      Dir.chdir(File.expand_path(path), &)
      puts "cd back #{Dir.pwd}".info2
    end

    def rm_rf(path, sudo: false)
      commands = [
        sudo ? "sudo" : "",
        "rm -rf",
        path
      ]

      bash(commands.join(" "))
    end

    def cp(content, destination_path, sudo: false)
      commands = [
        sudo ? "sudo" : "",
        "cp -r",
        content,
        destination_path,
        "> /dev/null"
      ]

      bash(commands.join(" "))
    end

    def mv(source_path, destination_path, sudo: false)
      commands = [
        sudo ? "sudo" : "",
        "mv",
        source_path,
        destination_path,
        "> /dev/null"
      ]

      bash(commands.join(" "))
    end
  end
end
