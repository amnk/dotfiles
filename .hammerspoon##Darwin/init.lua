-- Helper functions ---------------------------
require "windows"
require "mic"
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
    resize_win("halfleft")
  end)

  hs.hotkey.bind(cmd_alt, "l", function()
    resize_win("halfright")
  end)

  hs.hotkey.bind(cmd_alt, "i", function()
    resize_win("halfup")
  end)

  hs.hotkey.bind(cmd_alt, ",", function()
    resize_win("halfdown")
  end)

  hs.hotkey.bind(cmd_alt, "m", function()
    resize_win("fullscreen")
  end)

  hs.hotkey.bind(cmd_alt, "k", function()
    resize_win("center")
  end)

  -- Screen-related actions with Commnad+Shift+key

  --Bring focus to next display/screen
  hs.hotkey.bind(cmd_shift, "]", function()
    focusScreen(hs.window.focusedWindow():screen():next())
  end)

  --Bring focus to previous display/screen
  hs.hotkey.bind(cmd_shift, "[", function()
    focusScreen(hs.window.focusedWindow():screen():previous())
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
    local all_windows = hs.window.allWindows()
    hs.hints.windowHints(nil, focusWindow, true)
    -- hs.hints.windowHints(all_windows, focusWindow)
  end)

  -- Similar to hints, but different :)
  hs.hotkey.bind(cmd_shift, "o", function()
    expose:toggleShow()
  end)

  -- Lock screen (e.g. launch screensaver which requires password)
  hs.hotkey.bind(cmd_shift, "k", function()
    os.execute('/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine')
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
function init()
  -- Defaults
  hs.hotkey.alertDuration = 0
  hs.hints.showTitleThresh = 20
  hs.hints.titleMaxSize = 6
  createHotkeys()
  initGrid()
  hs.window.animationDuration = 0
end

-- workaround https://github.com/Hammerspoon/hammerspoon/issues/1163
layout = hs.keycodes.currentLayout()
if layout ~= "U.S." then
        hs.keycodes.setLayout("U.S.")
        init()
else
        init()
end
