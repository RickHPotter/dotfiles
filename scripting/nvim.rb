# frozen_string_literal: true

module Scripting
  class Nvim
    def self.run
      new.run
    end

    def run
      install_neovim
      install_hazyvim

      setup_ruby
      setup_javascript
      setup_golang
      setup_rust
    end

    protected

    def install_neovim
      bash("curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz")
      bash("tar -xf nvim-linux64.tar.gz && mv nvim-linux64 /home/#{current_user}/nvim")
    end

    def install_hazyvim
      mkdir_p("~/.config/nvim")
      git_clone("RickHPotter/hazyvim.nvim", "~/.config/nvim")
    end

    def setup_ruby
      bash("gem install solargraph neovim bundler")
    end

    def setup_javascript
      bash("npm install -s -g neovim diagnostic-languageserver -y")
    end

    def setup_golang
      bash("go install mvdan.cc/gofumpt@latest")
      bash("go install -v github.com/incu6us/goimports-reviser/v3@latest")
      bash("go install github.com/segmentio/golines@latest")
    end

    def setup_rust
      bash("rustup component add rust-analyzer")
      bash("sudo apt-get update")
      bash("sudo apt-get install -y lldb")
    end
  end
end
