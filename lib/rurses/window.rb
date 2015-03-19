module Rurses
  class Window
    MODE_NAMES = {
      c_break:      :cbreak,
      no_echo:      :noecho,
      keypad:       [:keypad, :window, true],
      hide_cursor:  [:curs_set, 0],
      non_blocking: [:timeout, 0]
    }
    ATTRIBUTES = Hash.new { |all, name|
      all[name] = Rurses.curses.const_get("A_#{name.upcase}")
    }

    def initialize(**details)
      @curses_ref      = details.fetch(:curses_ref) {
        Rurses.curses.newwin(
          details.fetch(:lines),
          details.fetch(:columns),
          details.fetch(:y),
          details.fetch(:x)
        )
      }
      @standard_screen = details.fetch(:standard_screen) { false }
      @subwindows      = { }
    end

    attr_reader :curses_ref, :subwindows

    def standard_screen?
      @standard_screen
    end

    def cursor_x
      Rurses.curses.getcurx(curses_ref)
    end

    def cursor_y
      Rurses.curses.getcury(curses_ref)
    end

    def cursor_xy
      y, x = Rurses.curses.getyx(curses_ref)
      {x: x, y: y}
    end

    def columns
      Rurses.curses.getmaxx(curses_ref)
    end

    def lines
      Rurses.curses.getmaxy(curses_ref)
    end

    def size
      {columns: columns, lines: lines}
    end

    def resize(lines: , columns: )
      Rurses.curses.resizeterm(lines, columns) if standard_screen?
      Rurses.curses.wresize(curses_ref, lines, columns)
    end

    def change_modes(modes)
      modes.each do |name|
        mode = Array(MODE_NAMES[name] || name)
        Rurses.curses.send(*mode.map { |arg| arg == :window ? curses_ref : arg })
      end
    end

    def draw_border( left:     0, right:     0, top:         0, bottom:       0,
                     top_left: 0, top_right: 0, bottom_left: 0, bottom_right: 0 )
      args = [
        left,     right,     top,         bottom,
        top_left, top_right, bottom_left, bottom_right
      ].map { |c| c.is_a?(String) ? c.encode("UTF-8").codepoints.first : c }
      if args.any? { |c| c >= 128 }
        Rurses.curses.wborder_set(
          curses_ref,
          *args.map { |c|
            char            = Rurses.curses::WinStruct::CCharT.new
            char[:chars][0] = c
          }
        )
      else
        Rurses.curses.wborder(curses_ref, *args)
      end
    end

    def move_cursor(x: , y: )
      Rurses.curses.wmove(curses_ref, y, x)
    end

    def draw_string(content)
      Rurses.curses.waddstr(curses_ref, content)
    end

    def draw_string_on_a_line(content)
      old_y = cursor_y
      draw_string(content)
      new_y = cursor_y
      move_cursor(x: 0, y: new_y + 1) if new_y == old_y
    end

    def skip_line
      move_cursor(x: 0, y: cursor_y + 1)
    end

    def style(*attributes)
      attributes.each do |attribute|
        Rurses.curses.wattron(curses_ref, ATTRIBUTES[attribute])
      end
      yield
    ensure
      attributes.each do |attribute|
        Rurses.curses.wattroff(curses_ref, ATTRIBUTES[attribute])
      end
    end

    def clear(reset_cursor: true)
      Rurses.curses.wclear(curses_ref)
      move_cursor(x: 0, y: 0) if reset_cursor
    end

    def refresh_in_memory
      Rurses.curses.wnoutrefresh(curses_ref)
    end

    def create_subwindow( name: , top_padding:   0, left_padding:   0,
                                  right_padding: 0, bottom_padding: 0 )
      s                = size
      xy               = cursor_xy
      subwindows[name] =
        self.class.new(
          curses_ref: Rurses.curses.derwin(
            curses_ref,
            s[:lines]   - (top_padding  + bottom_padding),
            s[:columns] - (left_padding + right_padding),
            xy[:y]      + top_padding,
            xy[:x]      + left_padding
          )
        )
    end

    def subwindow(name)
      subwindows[name]
    end
  end
end
