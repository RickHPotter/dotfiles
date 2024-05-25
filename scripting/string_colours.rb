# frozen_string_literal: true

class String
  COLOURS = {
    black: 30,
    red: 31,
    green: 32,
    yellow: 33,
    blue: 34,
    magenta: 35,
    cyan: 36,
    white: 37
  }.freeze

  BACKGROUNDS = {
    bg_black: 40,
    bg_red: 41,
    bg_green: 42,
    bg_yellow: 43,
    bg_blue: 44,
    bg_magenta: 45,
    bg_cyan: 46,
    bg_white: 47
  }.freeze

  ATTRIBUTES = {
    bold: [1, 22],
    italic: [3, 23],
    underline: [4, 24],
    blink: [5, 25],
    reverse_color: [7, 27]
  }.freeze

  COLOURS.merge(BACKGROUNDS).each do |key, value|
    define_method(key) do
      "\e[#{value}m#{self}\e[0m"
    end
  end

  ATTRIBUTES.each do |key, (on, off)|
    define_method(key) do
      "\e[#{on}m#{self}\e[#{off}m"
    end
  end

  # PRESETS
  def delimiter
    "                                                ".underline
  end

  def start
    "#{delimiter}\n\n#{bg_black.blue.bold}"
  end

  def end
    "#{bg_black.green.bold.blink}\n#{delimiter}"
  end

  def info1
    bg_black.cyan.bold
  end

  def info2
    bg_black.white.bold
  end

  def warning
    bg_black.yellow.bold
  end

  def success
    bg_black.green.bold
  end

  def error
    bg_black.red.bold
  end
end
