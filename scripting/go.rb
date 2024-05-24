# frozen_string_literal: true

require_relative "util"

module Scripting
  class Go < Scripting::Util
    def self.run
      new.run
    end

    def run
      file = "go1.22.3.linux-amd64.tar.gz"
      link = "https://go.dev/dl/#{file}"
      rm_rf("/usr/local/go")
      download(link)
      bash("sudo tar -C /usr/local -xzf #{file}")

      rm_rf(file)

      p "Go was successfully installed."
    end
  end
end
