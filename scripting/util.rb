# frozen_string_literal: true

require "fileutils"
require "open3"

module Scripting
  class Util
    include FileUtils

    def initialize; end

    def bash(command)
      puts "Running: #{command}"
      stdout, stderr, status = Open3.capture3(command)

      unless status.success?
        puts "Error: #{stderr}"
        exit 1
      end

      puts stdout
    end

    def bashs(commands: [])
      commands.each do |command|
        bash(command)
      end
    end

    def git_clone(repo, path = "")
      bash("git clone https://github.com/#{repo} #{path}")
    end

    def download(url)
      bash("curl -O #{url}")
    end

    def cd(path, &block)
      Dir.chdir(path, &block)
    end

    def rm_rf(path)
      FileUtils.rm_rf(path)
    end
  end
end
