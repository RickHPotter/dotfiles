# frozen_string_literal: true

require "optparse"

require_relative "scripting/terminal"
require_relative "scripting/touchcursor"
require_relative "scripting/postgresql"
require_relative "scripting/oracle"

require_relative "scripting/nvm"
require_relative "scripting/go"
require_relative "scripting/flutter"
require_relative "scripting/rust"

require_relative "scripting/zshrc"
require_relative "scripting/nvim"

options = { except_neovim: true, only_neovim: false }

OptionParser.new do |opts|
  opts.on("--except-neovim", "Except Neovim // DEFAULT") do
    options[:skip_nvm] = false
  end

  opts.on("--only-neovim", "Only Neovim") do
    options[:skip_go] = true
  end
end.parse!

if options[:except_neovim]
  Scripting::Terminal.run
  Scripting::Touchcursor.run
  # Scripting::Postgresql.run
  Scripting::Oracle.run

  Scripting::Nvm.run
  Scripting::Go.run
  Scripting::Flutter.run
  Scripting::Rust.run
  Scripting::Zshrc.run
end

Scripting::Nvim.run if options[:only_neovim]

p "Things that are missing:"
p "  - Setup Git Keys"
p "  - Setup Codeium, runninig :Codeium Auth on nvim"
p "  - Download Opera (personal) and Chrome (AndroidStudio and Capybara)"
p "  - Download Discord"
p "  - Download Dbeaver"
p "  - Download Spotify"
