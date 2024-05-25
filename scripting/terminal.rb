# frozen_string_literal: true

require "shellwords"
require_relative "util"

module Scripting
  class Terminal < Scripting::Util
    def self.run
      new.run
    end

    def run
      install_oh_my_zsh
      install_tmux_and_plugins
      install_lazygit
      install_neovim
      install_fonts
      install_exa
    end

    def install_oh_my_zsh
      rm_rf("~/Downloads/ohmyzsh")
      rm_rf("~/.oh-my-zsh")

      git_clone("ohmyzsh/ohmyzsh.git", "~/Downloads/ohmyzsh")
      cd("~/Downloads/ohmyzsh") do
        bash("./tools/install.sh -s -- --yes")
      end

      rm_rf("~/Downloads/ohmyzsh")

      p "OhMyZsh was successfully installed."
    end

    def install_tmux_and_plugins
      rm_rf("~/.tmux/plugins/tpm")
      git_clone("tmux-plugins/tpm", "~/.tmux/plugins/tpm")

      cp(File.join(config_files_dir, ".tmux.conf"), "~/")
      cp(File.join(config_files_dir, ".tmux.reset.conf"), "~/")

      bash("curl -sS https://starship.rs/install.sh | sh -s -- --yes")

      cp(File.join(config_files_dir, "starship.toml"), "~/.config/starship.toml")

      p "Tmux, plugins and Starship were successfully installed."
    end

    def install_lazygit
      lazygit_git = "https://api.github.com/repos/jesseduffield/lazygit/releases/latest"
      version = `curl -s "#{lazygit_git}" | grep -Po '"tag_name": "v\\K[^"]*'`.strip

      cd("~/Downloads") do
        download("https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_#{version}_Linux_x86_64.tar.gz", "lazygit.tar.gz")
        bash("tar xf lazygit.tar.gz lazygit")
        bash("sudo install lazygit /usr/local/bin")
      end

      rm_rf("~/Downloads/lazygit.tar.gz")
      rm_rf("~/Downloads/lazygit")

      p "Lazygit was successfully installed."
    end

    def install_neovim
      rm_rf("~/nvim")

      cd("~/Downloads") do
        download("https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz")
        bash("tar -xf nvim-linux64.tar.gz")
        mv("nvim-linux64", "~/nvim", sudo: true)
      end

      rm_rf("~/Downloads/nvim-linux64")
      rm_rf("~/Downloads/nvim-linux64.tar.gz")

      p "Neovim was successfully installed."
    end

    def install_fonts
      fonts_dir = "/usr/share/fonts/"
      mkdir_p(fonts_dir, sudo: true)

      file_paths = Dir.glob(File.join(assets_dir, "fonts", "*.{ttf,otf}")).map { |path| Shellwords.escape(path) }.join(" ")
      cp(file_paths, fonts_dir, sudo: true)
      bash("fc-cache -f")

      p "Fonts were successfully installed."
    end

    def install_exa
      cd("/usr/local/bin") do
        download("https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip", sudo: true)
        bash("sudo unzip -o exa-linux-x86_64-v0.10.0.zip")
        rm_rf("exa-linux-x86_64-v0.10.0.zip", sudo: true)
      end

      p "Exa was successfully installed."
    end
  end
end
