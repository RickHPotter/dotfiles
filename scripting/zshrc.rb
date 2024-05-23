# frozen_string_literal: true

require_relative "utils"

module Scripting
  class Zshrc < Scripting::Util
    def self.run
      new.run
    end

    def run
      rm_rf("~/.zshrc")
      cp("config_files/zshrc/*", "~/")
    end
  end
end
