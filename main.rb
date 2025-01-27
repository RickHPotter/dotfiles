# frozen_string_literal: true

require "optparse"

require_relative "scripting/string_colours"

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

options = { except_neovim: false, only_neovim: false, postgres: true, oracle: true, flutter: true }

OptionParser.new do |opts|
  opts.on("--except-neovim", "Except Neovim // DEFAULT") do
    options[:except_neovim] = true
  end

  opts.on("--only-neovim", "Only Neovim") do
    options[:only_neovim] = true
  end

  opts.on("--no-postgres", "Except Postgres") do
    options[:postgres] = false
  end

  opts.on("--no-oracle", "Except Oracle") do
    options[:oracle] = false
  end

  opts.on("--no-flutter", "Except Flutter") do
    options[:flutter] = false
  end
end.parse!

if options[:except_neovim]
  Scripting::Terminal.run
  Scripting::Touchcursor.run
  Scripting::Nvm.run
  Scripting::Go.run
  Scripting::Rust.run
  Scripting::Postgresql.run if options[:postgres]
  Scripting::Oracle.run     if options[:oracle]
  Scripting::Flutter.run    if options[:flutter]
  Scripting::Zshrc.run
end

if options[:only_neovim]
  Scripting::Nvim.run

  puts "".delimiter
  puts "THINGS THAT ARE MISSING:".warning
  puts "\
  - In Ubuntu Terminal Preferences, opt in `Run command as Login Shell` and add the custom command `zsh --login`
  - Setup Git Keys
    - `ssh-keygen -t ed25519`
    - `cat ~/.ssh/id_ed25519.pub`
    - https://github.com/settings/ssh/new
    - `git config --global user.name RickHPotter`
    - `git config --global user.email luisfla55@hotmail.com`
  - Setup Codeium, runninig :Codeium Auth on nvim - https://www.codeium.com/profile?response_type=token&redirect_uri=vim-show-auth-token&state=a&scope=openid%20profile%20email&redirect_parameters_type=query
  - Download Opera (personal) and Chrome (AndroidStudio and Capybara)
  - Download Discord
  - Download Dbeaver
  - Download Spotify
  - git clone https://github.com/Ld-Hagen/fix-opera-linux-ffmpeg-widevine.git".info1
  puts "".delimiter
end
