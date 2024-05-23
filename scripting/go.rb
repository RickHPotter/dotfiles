# frozen_string_literal: true

require_relative "util"

module Scripting
  class Go < Scripting::Util
    def self.run
      new.run
    end

    def run
      go = "go1.22.3.linux-amd64.tar.gz"
      link = "https://go.dev/dl/#{go}"
      rm_rf("/usr/local/go")
      download(link)
      bash("sudo tar -C /usr/local -xzf #{go}")
    end
  end
end
