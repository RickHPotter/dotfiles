# frozen_string_literal: true

require_relative "util"

module Scripting
  class Rust < Scripting::Util
    def run
      puts "Installing Rust...".start

      bash("curl https://sh.rustup.rs -sSf | sh -s -- -y")
      bash("~/.cargo/bin/rustup -q default stable")

      puts "Rust was successfully installed.".end
    end
  end
end
