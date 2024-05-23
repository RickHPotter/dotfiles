# frozen_string_literal: true

require_relative "util"

module Scripting
  class Terminal < Scipting::Util
    def self.run
      new.run
    end

    def run
      install_oh_my_zsh
      install_tmux_and_plugins
      install_lazygit
      install_fonts
    end

    protected

    def install_oh_my_zsh
      bash('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"')

      zsh_config = "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins"
      git_clone("zsh-users/zsh-syntax-highlighting.git", "#{zsh_config}/zsh-syntax-highlighting")
      git_clone("zsh-users/zsh-autosuggestions.git",     "#{zsh_config}/zsh-autosuggestions")
    end

    def install_tmux_and_plugins
      git_clone("tmux-plugins/tpm", "~/.tmux/plugins/tpm")

      bash("curl -sS https://starship.rs/install.sh | sh")
      bash("cp config_files/starship.toml /home/#{current_user}/.config/starship.toml")
    end

    def install_lazygit
      lazygit_git = "https://api.github.com/repos/jesseduffield/lazygit/releases/latest"
      version = `curl -s "#{lazygit_git}" | grep -Po '"tag_name": "v\\K[^"]*'`.strip

      bash("curl -Lo lazygit.tar.gz \"https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_#{version}_Linux_x86_64.tar.gz\"")
      bash("tar xf lazygit.tar.gz lazygit")
      bash("sudo install lazygit /usr/local/bin")
    end

    def install_fonts
      fonts_dir = "/user/share/fonts/"
      mkdir_p(fonts_dir)

      cp("config_files/fonts/*.{ttf,otf}", fonts_dir)
      bash("fc-cache -f -v")
    end
  end
end
