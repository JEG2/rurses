module Rurses
  class PanelStack
    def initialize
      @window_to_panel_map = { }
    end

    attr_reader :window_to_panel_map
    private     :window_to_panel_map

    def add(window, add_subwindows: true)
      window_to_panel_map[window] = Rurses.curses.new_panel(window.curses_ref)
      if add_subwindows
        window.subwindows.each_value do |subwindow|
          add(subwindow, add_subwindows: add_subwindows)
        end
      end
    end
    alias_method :<<, :add

    def remove(window, remove_subwindows: true)
      if remove_subwindows
        window.subwindows.each_value do |subwindow|
          remove(subwindow, remove_subwindows: remove_subwindows)
        end
      end
      window.clear
      Rurses.curses.del_panel(window_to_panel_map[window])
      Rurses.curses.delwin(window.curses_ref)
    end

    def refresh_in_memory
      Rurses.curses.update_panels
    end
  end
end
