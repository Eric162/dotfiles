-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- Colors
local my_dimmed_monokai = wezterm.get_builtin_color_schemes()['DimmedMonokai']
my_dimmed_monokai.foreground = 'gray'
my_dimmed_monokai.background = '#1B1B1B' -- 1E1E1E originally
my_dimmed_monokai.cursor_bg = 'grey'
my_dimmed_monokai.cursor_border = my_dimmed_monokai.cursor_bg

config.color_schemes = {
  ['DimmedMonokai'] = my_dimmed_monokai
}

-- browns
-- config.color_scheme = 'Marrakesh (base16)'
-- blues
-- config.color_scheme = 'Mirage'
-- config.color_scheme = 'PhD (base16)'
-- config.color_scheme = 'Solarized (dark) (terminal.sexy)'
-- config.color_scheme = 'Atlas (base16)'
-- mains
config.color_scheme = 'DimmedMonokai'
-- config.color_scheme = 'Pretty and Pastel (terminal.sexy)'
-- config.color_scheme = 'Tangoesque (terminal.sexy)' -- red symlinks -> pink
-- config.color_scheme = 'Equilibrdium Gray Dark (base16)'
-- config.color_scheme = 'Terminix Dark (Gogh)' -- purple synlinks -> pink


-- Tab bar
config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font { family = 'JetBrains' },
  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 12.0,
}

config.colors = {
  tab_bar = {
    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      fg_color = '#CCCCCC',
      bg_color = config.color_schemes['DimmedMonokai'].background,
    },
  }
}

config.tab_bar_at_bottom = true
-- config.cursor_blink_rate = 800

--  right status bar display date/time
wezterm.on("update-status", function(window, pane)
  -- demonstrates shelling out to get some external status.
  -- wezterm will parse escape sequences output by the
  -- child process and include them in the status area, too.
  -- local success, date, stderr = wezterm.run_child_process({ "date" });

  -- However, if all you need is to format the date/time, then:
  date = wezterm.strftime("  %A %b %d  ");
  date_time = wezterm.strftime("  %H:%M:%S  ");

  -- Make it italic and underlined
  window:set_right_status(wezterm.format({
    { Background = { Color = "666" } },
    { Foreground = { Color = "111" } },
    { Text = date },
    { Background = { Color = "888" } },
    { Foreground = { Color = "111" } },
    { Text = date_time },
  }));
end);

-- keybinds
-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'c',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'x',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentTab { domain = 'DefaultDomain', confirm = false },
  },
  -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  {
    key = 'a',
    mods = 'LEADER|CTRL',
    action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
  },
}

-- and finally, return the configuration to wezterm
return config
