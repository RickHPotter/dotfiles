# frozen_string_literal: true

require_relative "util"

module Scripting
  class Nvm < Scripting::Util
    def self.run
      new.run
    end

    def run
      bash("curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash")

      bash('export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install node')

      p "Nvm and Node were successfully installed."
    end
  end
end
