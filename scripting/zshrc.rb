# frozen_string_literal: true

require_relative "util"

module Scripting
  class Zshrc < Scripting::Util
    def self.run
      new.run
    end

    def run
      rm_rf("~/.zshrc")
      rm_rf("~/.zshrc.d")

      cp(File.join(config_files_dir, "zshrc", ".zshrc"), "~/")

      mkdir_p("~/.zshrc.d")
      cp(File.join(config_files_dir, "zshrc", ".zshrc.d", "aliases.zsh"), "~/.zshrc.d/")
      cp(File.join(config_files_dir, "zshrc", ".zshrc.d", "paths.zsh"),   "~/.zshrc.d/")
      cp(File.join(config_files_dir, "zshrc", ".zshrc.d", "siedos.zsh"),  "~/.zshrc.d/")

      p "Run the following command to refresh the terminal"
      p "source ~/.zshrc"
    end
  end
end
