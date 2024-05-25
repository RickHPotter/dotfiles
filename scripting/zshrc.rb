# frozen_string_literal: true

require_relative "util"

module Scripting
  class Zshrc < Scripting::Util
    def self.run
      new.run
    end

    def run
      install_plugins
      update_zshrc_config

      p "Zshrc files have been successfully moved."
    end

    protected

    def install_plugins
      zsh_config = "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins"

      rm_rf("#{zsh_config}/zsh-syntax-highlighting", sudo: true)
      rm_rf("#{zsh_config}/zsh-autosuggestions", sudo: true)

      git_clone("zsh-users/zsh-syntax-highlighting.git", "#{zsh_config}/zsh-syntax-highlighting")
      git_clone("zsh-users/zsh-autosuggestions.git",     "#{zsh_config}/zsh-autosuggestions")

      download("https://raw.githubusercontent.com/ogham/exa/master/contrib/completions.zsh")
      mv("completions.zsh", "/usr/local/share/zsh/site-functions", sudo: true)
    end

    def update_zshrc_config
      rm_rf("~/.zshrc")
      rm_rf("~/.zshrc.d")

      cp(File.join(config_files_dir, "zshrc", ".zshrc"), "~/")

      mkdir_p("~/.zshrc.d")
      cp(File.join(config_files_dir, "zshrc", ".zshrc.d", "aliases.zsh"), "~/.zshrc.d/")
      cp(File.join(config_files_dir, "zshrc", ".zshrc.d", "paths.zsh"),   "~/.zshrc.d/")
      cp(File.join(config_files_dir, "zshrc", ".zshrc.d", "siedos.zsh"),  "~/.zshrc.d/")
    end
  end
end
