# frozen_string_literal: true

require_relative "util"

module Scripting
  class Zshrc < Scripting::Util
    attr_reader :zsh_config

    def initialize
      @zsh_config = "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins"
      super
    end

    def run
      puts "Installing Zshrc plugins and updating config...".start

      install_plugins
      update_zshrc_config

      puts "Zshrc plugins and config were successfully updated.".end
    end

    protected

    def install_plugins
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

      mkdir_p("~/.zshrc.d")

      cp(File.join(config_files_dir, "zshrc", ".zshrc"), "~/")
      cp(File.join(config_files_dir, "zshrc", ".zshrc.d", "*"), "~/.zshrc.d/")
    end
  end
end
