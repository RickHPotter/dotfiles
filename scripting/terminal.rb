# frozen_string_literal: true

require "shellwords"
require_relative "util"

module Scripting
  class Terminal < Scripting::Util
    def self.run(options = {})
      new.run(options)
    end

    def run(options = {})
      install_oh_my_zsh
      install_kitty if options[:kitty]
      install_tmux_and_plugins
      install_lazygit
      install_neovim
      install_fonts if options[:fonts]
      install_exa

      setup_git if options[:git]
    end

    protected

    def install_oh_my_zsh
      puts "Installing OhMyZsh...".start

      rm_rf("~/.oh-my-zsh")
      rm_rf("~/.zshrc.pre-oh-my-zsh*")

      git_clone("ohmyzsh/ohmyzsh.git", "~/Downloads/ohmyzsh")
      cd("~/Downloads/ohmyzsh") do
        bash("./tools/install.sh -s -- --yes")
      end

      rm_rf("~/Downloads/ohmyzsh")

      bash("chsh -s $(which zsh)")

      puts "OhMyZsh was successfully installed.".end
    end

    def install_kitty
      puts "Installing Kitty Terminal...".start

      bash("curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin")
      mkdir_p("~/.config/kitty")
      cp(File.join(config_files_dir, "kitty", "*"), "~/.config/kitty/")

      # cd /usr/lib/
      # sudo mkdir kitty
      # cd kitty
      # sudo mkdir logo
      # cd logo
      # sudo wget https://github.com/k0nserv/kitty-icon/blob/main/build/neue_ember.iconset/icon_128x128.png
      # sudo mv icon_128x128.png kitty-128.png
      # sudo rm -rf kitty.png
      # sudo wget https://github.com/k0nserv/kitty-icon/blob/main/build/neue_ember.iconset/icon_32x32.png
      # sudo mv icon_32x32.png kitty.png

      puts "Kitty was successfully installed.".end
    end

    def install_tmux_and_plugins
      puts "Installing Tmux and plugins...".start

      rm_rf("~/.tmux/plugins/tpm")
      git_clone("tmux-plugins/tpm", "~/.tmux/plugins/tpm")

      cp(File.join(config_files_dir, ".tmux.conf"), "~/")
      cp(File.join(config_files_dir, ".tmux.reset.conf"), "~/")

      bash("curl -sS https://starship.rs/install.sh | sh -s -- --yes > /dev/null")

      mkdir_p("~/.config")
      cp(File.join(config_files_dir, "starship.toml"), "~/.config/starship.toml")

      puts "Tmux, plugins and Starship were successfully installed.".end
    end

    def install_lazygit
      puts "Installing Lazygit...".start

      lazygit_git = "https://api.github.com/repos/jesseduffield/lazygit/releases/latest"
      version = `curl -s "#{lazygit_git}" | grep -Po '"tag_name": "v\\K[^"]*'`.strip

      cd("~/Downloads") do
        download("https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_#{version}_Linux_x86_64.tar.gz", "lazygit.tar.gz")
        bash("tar xf lazygit.tar.gz lazygit")
        bash("sudo install lazygit /usr/local/bin")
      end

      rm_rf("~/Downloads/lazygit.tar.gz")
      rm_rf("~/Downloads/lazygit")

      puts "Lazygit was successfully installed.".end
    end

    def install_neovim
      puts "Installing Neovim...".start

      rm_rf("~/nvim")

      cd("~/Downloads") do
        download("https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz")
        bash("tar -xf nvim-linux-x86_64.tar.gz")
        mv("nvim-linux-x86_64", "~/nvim", sudo: true)
      end

      rm_rf("~/Downloads/nvim-linux-x86_64")
      rm_rf("~/Downloads/nvim-linux-x86_64.tar.gz")

      puts "Neovim was successfully installed.".end
    end

    def install_fonts
      puts "Installing Fonts...".start

      fonts_dir = "/usr/share/fonts/"
      mkdir_p(fonts_dir, sudo: true)

      file_paths = Dir.glob(File.join(assets_dir, "fonts", "*.{ttf,otf}")).map { |path| Shellwords.escape(path) }.join(" ")
      cp(file_paths, fonts_dir, sudo: true)
      bash("fc-cache -f")

      puts "Fonts were successfully installed.".end
    end

    def install_exa
      puts "Installing Exa...".start

      cd("/usr/local/bin") do
        download("https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip", sudo: true)
        bash("sudo unzip -qq -o exa-linux-x86_64-v0.10.0.zip -d exa")
        rm_rf("exa-linux-x86_64-v0.10.0.zip", sudo: true)
      end

      puts "Exa was successfully installed.".end
    end

    def setup_git
      puts "Setting up Git...".start

      bash("ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa")
      puts "Copy the public key below:".yellow
      bash("cat ~/.ssh/id_rsa.pub")
      puts "Paste the public key here:".yellow
      puts "https://github.com/settings/ssh/new".blue
      gets "Give me your GitHub username: " do |username|
        bash("git config --global user.name #{username}")
      end
      gets "Give me your GitHub email: " do |email|
        bash("git config --global user.email #{email}")
      end

      puts "Git was successfully setup.".end
    end
  end
end
