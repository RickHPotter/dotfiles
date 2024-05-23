# frozen_string_literal: true

require_relative "scripting/terminal"
require_relative "scripting/touchcursor"
require_relative "scripting/nvm"
require_relative "scripting/postgresql"
require_relative "scripting/oracle"
require_relative "scripting/go"
require_relative "scripting/flutter"
require_relative "scripting/rust"
require_relative "scripting/nvim"
require_relative "scripting/zshrc"

Scripting::Terminal.run
Scripting::Touchcursor.run
Scripting::Nvm.run
Scripting::Postgresql.run
Scripting::Oracle.run
Scripting::Go.run
Scripting::Flutter.run
Scripting::Rust.run
Scripting::Nvim.run
Scripting::Zshrc.run
