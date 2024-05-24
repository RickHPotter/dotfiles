# frozen_string_literal: true

require_relative "util"

module Scripting
  class Rust < Scripting::Util
    def self.run
      new.run
    end

    def run
      bash("curl -y --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y")

      p "Rust was successfully installed"
    end
  end
end
