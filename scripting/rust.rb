# frozen_string_literal: true

require_relative "util"

module Scripting
  class Rust < Scripting::Util
    def run
      puts "Installing Rust...".start

      bash("curl -y --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -q -y")
      bash("rustup -q default stable")

      puts "Rust was successfully installed.".end
    end
  end
end
