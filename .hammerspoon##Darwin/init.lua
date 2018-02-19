-- Helper functions ---------------------------
local windows = require "windows"
require "mic"

local laptop_display = "Color LCD"
local right_display = "DELL P2417H"

local work_layout = {
    {"Slack",             nil,          right_display, nil,                 windows.layout.halfdown, nil},
    {"Skype",             nil,          right_display, nil,                 windows.layout.halfdown, nil},
    {"Telegram",          nil,          right_display, nil,                 windows.layout.halfdown, nil},
    {"iTerm2",            nil,          right_display, hs.layout.maximized, nil,                     nil},
    {"Code",              nil,          right_display, hs.layout.maximized, nil,                     nil},
}

local single_layout = {
    {"Slack",             nil,          laptop_display, hs.layout.maximized, nil,                      nil},
    {"Skype",             nil,          laptop_display, nil,                 windows.layout.halfright, nil},
    {"Telegram",          nil,          laptop_display, nil,                 windows.layout.halfright, nil},
    {"iTerm2",            nil,          laptop_display, hs.layout.maximized, nil,                      nil},
    {"Code",              nil,          laptop_display, hs.layout.maximized, nil,                      nil},
}

-- https://github.com/schlomo/hammerspoon-config/blob/master/init.lua#L42
function screenWatcher_function()
    newNumberOfScreens = #hs.screen.allScreens()

    if newNumberOfScreens == 1 then
        hs.layout.apply(single_layout)
        print('-------- Applied single monitor layout')
    elseif newNumberOfScreens == 2 then
        hs.layout.apply(work_layout)
        print('-------- Applied dual monitor layout')
    end
end

-----------------------------------------------
function createHotkeys()
  ---------------------------------------------------
  expose = hs.expose.new(nil,{showThumbnails=true})
  ---------------------------------------------------
  
  local cmd_alt   = {"cmd", "alt"}
  local cmd_shift = {"cmd", "shift"}
  local cmd_ctrl  = {"cmd", "control"}
  local cmd       = {"cmd"}

  -- Window actions with Command+key
  hs.hotkey.bind(cmd_alt, "j", function()
    windows.resize_win("halfleft")
  end)

  hs.hotkey.bind(cmd_alt, "l", function()
    windows.resize_win("halfright")
  end)

  hs.hotkey.bind(cmd_alt, "i", function()
    windows.resize_win("halfup")
  end)

  hs.hotkey.bind(cmd_alt, ",", function()
    windows.resize_win("halfdown")
  end)

  hs.hotkey.bind(cmd_alt, "m", function()
    windows.resize_win("fullscreen")
  end)

  hs.hotkey.bind(cmd_alt, "k", function()
    windows.resize_win("center")
  end)

  -- Screen-related actions with Commnad+Shift+key

  --Bring focus to next display/screen
  hs.hotkey.bind(cmd_shift, "]", function()
    windows.focusScreen(hs.window.focusedWindow():screen():next())
  end)

  --Bring focus to previous display/screen
  hs.hotkey.bind(cmd_shift, "[", function()
    windows.focusScreen(hs.window.focusedWindow():screen():previous())
  end)

  -- Move to the next screen
  hs.hotkey.bind(cmd_shift, "left", function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenWest()
  end)

  hs.hotkey.bind(cmd_shift, "right", function()
    local win = hs.window.focusedWindow()
    win:moveOneScreenEast()
  end)

  -- Global actions with cmd_shift
  --
  -- Reload config
  hs.hotkey.bind(cmd_shift, "r", hs.reload)

  -- Hint with all open applications
  hs.hotkey.bind(cmd_shift, "l", function()
    hs.hints.windowHints(nil, windows.focusWindow)
  end)

  -- Similar to hints, but different :)
  hs.hotkey.bind(cmd_shift, "o", function()
    expose:toggleShow()
  end)

  -- Lock screen (e.g. launch screensaver which requires password)
  hs.hotkey.bind(cmd_shift, "k", function() 
    hs.caffeinate.startScreensaver()
  end)

  -- Mute microphone
  hs.hotkey.bind(cmd_shift, "m", function()
    toggleMicMute()
  end)

  hs.alert.show("Hammerspoon, at your service.")
end
---------------------------------------------
function initGrid()
  hs.grid.setGrid('1x3', 'DELL P2417H')
end
---------------------------------------------
function caffeinateWatcher(event)
    screenWatcher:start()
end
---------------------------------------------
function main()
  -- defaults
  hs.hotkey.alertDuration = 0
  hs.hints.showTitleThresh = 20
  hs.hints.titleMaxSize = 6
  hs.window.animationDuration = 0
  ------
  -- startup functions
  createHotkeys()
  initGrid()
  ------
  -- watchers
  screenWatcher = hs.screen.watcher.new(screenWatcher_function)
  screenWatcher:start()
  hs.caffeinate.watcher.new(caffeinateWatcher):start()
  ------
end

-- workaround https://github.com/Hammerspoon/hammerspoon/issues/1163
layout = hs.keycodes.currentLayout()
if layout ~= "U.S." then
        hs.keycodes.setLayout("U.S.")
        main()
else
        main()
end
