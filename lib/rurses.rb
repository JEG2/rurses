require "ffi-ncurses"

require_relative "rurses/version"
require_relative "rurses/panel_stack"
require_relative "rurses/window"

module Rurses
  SPECIAL_KEYS = Hash[
    FFI::NCurses::KeyDefs
      .constants
      .select { |name| name.to_s.start_with?("KEY_") }
      .map    { |name|
        [ FFI::NCurses::KeyDefs.const_get(name),
          name.to_s.sub(/\AKEY_/, "").to_sym ]
      }
  ]

  module_function

  def curses
    FFI::NCurses
  end

  def program(modes: [ ])
    @stdscr = Window.new(curses_ref: curses.initscr, standard_screen: true)
    @stdscr.change_modes(modes)
    yield(@stdscr)
  ensure
    curses.endwin
  end

  def stdscr
    @stdscr
  end

  def get_key
    case (char = curses.getch)
    when !SPECIAL_KEYS[char].nil?
      SPECIAL_KEYS[char]
    when curses::ERR
      nil
    when 127
      :BACKSPACE
    else
      char.chr
    end
  end

  def update_screen
    curses.doupdate
  end
end
