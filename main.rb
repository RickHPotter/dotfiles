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

options = {
  except_neovim: false,
  only_neovim: false,
  postgres: true,
  oracle: true,
  flutter: true,
  kitty: true,
  fonts: true,
  git: true
}

OptionParser.new do |opts|
  opts.on("--except-neovim", "Except Neovim // DEFAULT") do
    options[:except_neovim] = true
  end

  opts.on("--only-neovim", "Only Neovim") do
    options[:only_neovim] = true
  end

  %w[postgres oracle flutter kitty fonts git].each do |option|
    opts.on("--no-#{option}", "Except #{option.capitalize}") do
      options[option.to_sym] = false
    end
  end
end.parse!

if options[:except_neovim]
  Scripting::Terminal.run(options)
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
  - Setup Codeium, runninig :Codeium Auth on nvim - https://www.codeium.com/profile?response_type=token&redirect_uri=vim-show-auth-token&state=a&scope=openid%20profile%20email&redirect_parameters_type=query
  - Download Opera (personal), Chrome (AndroidStudio and Capybara), Discord, Dbeaver, Spotify.
  - git clone https://github.com/Ld-Hagen/fix-opera-linux-ffmpeg-widevine.git".info1
  puts "".delimiter
end
