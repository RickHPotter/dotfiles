# frozen_string_literal: true

require_relative "util"

module Scripting
  class Go < Scripting::Util
    attr_reader :file, :link

    def initialize
      @file = "go1.22.3.linux-amd64.tar.gz"
      @link = "https://go.dev/dl/#{file}"
      super
    end

    def run
      puts "Installing Go...".start

      rm_rf("/usr/local/go", sudo: true)

      download(link)
      bash("sudo tar -C /usr/local -xzf #{file}")
      rm_rf(file)

      puts "Go was successfully installed.".end
    end
  end
end
