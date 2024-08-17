# frozen_string_literal: true

require_relative "util"

module Scripting
  class Nvim < Scripting::Util
    attr_reader :source_file

    def initialize
      @source_file = "~/.config/nvim"
      mkdir_p(source_file)
      super
    end

    def run
      install_hazyvim

      setup_ruby
      setup_javascript
      setup_golang
      setup_rust
    end

    protected

    def install_hazyvim
      puts "Installing HazyVim...".start

      rm_rf(source_file)
      rm_rf("~.local/share/nvim")

      git_clone("RickHPotter/hazyvim.nvim", source_file)

      puts "HazyVim was successfully installed.".end
    end

    def setup_ruby
      puts "Setting up Ruby for Neovim...".start

      bash("gem install --silent solargraph neovim bundler")

      puts "Ruby was successfully setup for Neovim.".end
    end

    def setup_javascript
      puts "Setting up Javascript for Neovim...".start

      bash("npm install -s -g neovim diagnostic-languageserver @olrtg/emmet-language-server -y")

      puts "Javascript was successfully setup for Neovim.".end
    end

    def setup_golang
      puts "Setting up Golang for Neovim...".start

      bash("go install mvdan.cc/gofumpt@latest")
      bash("go install github.com/incu6us/goimports-reviser/v3@latest")
      bash("go install github.com/segmentio/golines@latest")

      puts "Golang was successfully setup for Neovim.".end
    end

    def setup_rust
      puts "Setting up Rust for Neovim...".start

      bash("rustup -q component add rust-analyzer")
      bash("sudo apt-get update -qq")
      bash("sudo apt-get install -qq lldb")

      puts "Rust was successfully setup for Neovim.".end
    end
  end
end

# NVIM .10 hasnt been a good start for Ruby on Rails
# Test one by one, maybe not all are necessary
# gem pristine json --version 2.7.2
# gem pristine racc --version 1.8.0
# gem pristine strscan --version 3.1.0
