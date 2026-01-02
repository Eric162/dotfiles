-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

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
my_dimmed_monokai.foreground = '999'
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

config.font = wezterm.font_with_fallback({ 'Menlo', 'Roboto Mono', 'JetBrains Mono', 'Monaco', 'monospace' })

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

config.native_macos_fullscreen_mode = true
config.tab_bar_at_bottom = true
-- disable ligatures
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
-- config.cursor_blink_rate = 800

-- Cache for git branches per pane (pane_id -> {cwd=..., branch=...})
local git_branch_cache = {}

-- Helper to extract path from file:// URI object
local function uri_to_path(cwd_uri)
    if not cwd_uri then
        return nil
    end
    -- Handle URL object (has file_path property)
    if type(cwd_uri) == 'userdata' then
        return cwd_uri.file_path
    end
    if type(cwd_uri) == 'table' and cwd_uri.file_path then
        return cwd_uri.file_path
    end
    -- String format: file://hostname/path
    if type(cwd_uri) == 'string' then
        return cwd_uri:gsub('file://[^/]*', '')
    end
    return nil
end

-- Update git branch cache for a pane (called from update-status)
local function update_git_branch_cache(pane)
    local cwd_uri = pane:get_current_working_dir()
    local cwd = uri_to_path(cwd_uri)
    local pane_id = pane:pane_id()

    if cwd then
        local success, stdout, stderr = wezterm.run_child_process({
            'git', '-C', cwd, 'rev-parse', '--abbrev-ref', 'HEAD'
        })
        local branch = nil
        if success and stdout then
            branch = stdout:gsub('%s+', '')
            if #branch == 0 then
                branch = nil
            end
        end
        git_branch_cache[pane_id] = { cwd = cwd, branch = branch }
    end
end

-- Tab title: show git branch if available, otherwise process name
-- Respects manually set tab titles (via LEADER + ,)
wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
    local tab_number = tab.tab_index + 1 -- 1-indexed for display
    local title

    -- Check if tab has a manually set title
    local tab_title = tab.tab_title
    if tab_title and #tab_title > 0 then
        title = tab_title
    else
        -- Check cache for git branch
        local pane_id = tab.active_pane.pane_id
        local cached = git_branch_cache[pane_id]
        if cached and cached.branch then
            title = cached.branch
        else
            -- Fall back to default: process name (basename only)
            local process = tab.active_pane.foreground_process_name or tab.active_pane.title or ''
            title = process:gsub('.*/', '')
        end
    end

    return tab_number .. ': ' .. title
end)

--  right status bar display date/time
wezterm.on("update-status", function(window, pane)
    -- Update git branch cache for tab title
    update_git_branch_cache(pane)

    -- However, if all you need is to format the date/time, then:
    local date = wezterm.strftime("  %A %b %d  ");
    local date_time = wezterm.strftime("  %H:%M:%S  ");

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
    -- Tabs
    {
        key = 'c',
        mods = 'LEADER',
        action = wezterm.action.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = ',',
        mods = 'LEADER',
        action = wezterm.action.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
    {
        -- Panes
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
        key = 'x',
        mods = 'LEADER',
        action = wezterm.action.CloseCurrentPane { domain = 'DefaultDomain', confirm = false },
    },
    {
        key = 'n',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = 'p',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        key = 'LeftArrow',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
        key = 'RightArrow',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
        key = 'UpArrow',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
        key = 'DownArrow',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Down',
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
        key = 'k',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
        key = 'j',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Down',
    },
    {
        key = 'z',
        mods = 'LEADER',
        action = wezterm.action.TogglePaneZoomState,
    },
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
        key = 'a',
        mods = 'LEADER|CTRL',
        action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
    },
    -- Make Command-Backspace equivalent to Ctrl-u; kill-line
    { key = 'Backspace', mods = 'CMD', action = act { SendString = '\x15' } },
}

-- Tabs nav by id
for i = 1, 9 do
    -- LEADER + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'LEADER',
        action = wezterm.action.ActivateTab(i - 1),
    })
end

config.scrollback_lines = 500000

-- and finally, return the configuration to wezterm
return config
