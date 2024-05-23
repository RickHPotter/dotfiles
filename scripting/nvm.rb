# frozen_string_literal: true

require_relative "utils"

module Scripting
  class Nvm < Scripting::Util
    def self.run
      new.run
    end

    def run
      bash("curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash")

      File.open("/home/#{current_user}/.zshrc", "a") do |f|
        f.puts 'export NVM_DIR="$HOME/.nvm"'
        f.puts '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm'
      end

      bash("source ~/.zshrc && nvm install node")
    end
  end
end
