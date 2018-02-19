local windows = {}

-- Maximize window size in current screen
function windows.maximizeWindow(win)
  local screenLocal = win:screen()
  local screen_frame = screenLocal:frame()
  win:setFrameWithWorkarounds(screen_frame)
end

-- Move window to the next screen and put mouth in its center
function windows.moveToNextScreen(win)
  local screen = win:screen()
  local nextScreen = screen:next()
  win:moveToScreen(nextScreen)
  coord = getWindowCenter(win)
  hs.mouse.setRelativePosition(coord, nextScreen)
end

function windows.getWindowCenter(win)
  local fr = win:frame()
  r = hs.geometry.new(fr.w/2,fr.h/2)
  return r
end

--Predicate that checks if a window belongs to a screen
function windows.isInScreen(screen, win)
  return win:screen() == screen
end

--TODO: move to separate screens.lua ?
function windows.focusScreen(screen)
  --Get windows within screen, ordered from front to back.
  --If no windows exist, bring focus to desktop. Otherwise, set focus on
  --front-most application window.
  local windows = hs.fnutils.filter(
      hs.window.orderedWindows(),
      hs.fnutils.partial(isInScreen, screen))
  local windowToFocus = #windows > 0 and windows[1] or hs.window.desktop()
  windowToFocus:focus()

  -- Move mouse to center of screen
  local pt = hs.geometry.rectMidPoint(screen:fullFrame())
  hs.mouse.setAbsolutePosition(pt)
  -- focusWindow(windowToFocus)
end

function windows.focusWindow(win)
  local geometry = win:frame()
  win:focus()
  hs.mouse.setAbsolutePosition(geometry.center)
end

function windows.resize_win(direction)
  local win = hs.window.focusedWindow()
  local frame = windows.frame_function(win, direction)
  win:setFrame(frame)
end

-- return Frame object for a window and particular layout
-- FIXME: better argument naming
function windows.frame_function(win, direction)
  local f = win:frame()
  local screen = win:screen()
  local localf = screen:absoluteToLocal(f)
  local max = screen:fullFrame()
  local stepw = max.w/30
  local steph = max.h/30

  if direction == "right" then
      localf.w = localf.w+stepw
      absolutef = screen:localToAbsolute(localf)
  end
  if direction == "left" then
      localf.w = localf.w-stepw
      absolutef = screen:localToAbsolute(localf)
  end
  if direction == "up" then
      localf.h = localf.h-steph
      absolutef = screen:localToAbsolute(localf)
  end
  if direction == "down" then
      localf.h = localf.h+steph
      absolutef = screen:localToAbsolute(localf)
  end
  if direction == "halfright" then
      localf.x = max.w/2 localf.y = 0 localf.w = max.w/2 localf.h = max.h
      absolutef = screen:localToAbsolute(localf)
  end
  if direction == "halfleft" then
      localf.x = 0 localf.y = 0 localf.w = max.w/2 localf.h = max.h
      absolutef = screen:localToAbsolute(localf)
  end
  if direction == "halfup" then
      localf.x = 0 localf.y = 0 localf.w = max.w localf.h = max.h/2
      absolutef = screen:localToAbsolute(localf)
  end
  if direction == "halfdown" then
      localf.x = 0 localf.y = max.h/2 localf.w = max.w localf.h = max.h/2
      absolutef = screen:localToAbsolute(localf)
  end
  if direction == "center" then
      localf.x = (max.w-localf.w)/2 localf.y = (max.h-localf.h)/2
      absolutef = screen:localToAbsolute(localf)
  end
  if direction == "fullscreen" then
      localf.x = 0 localf.y = 0 localf.w = max.w localf.h = max.h
      absolutef = screen:localToAbsolute(localf)
  end
  return absolutef
end

-- Helper functions for layout
local layout = {}

function layout.halfdown(win)
  frame = windows.frame_function(win, "halfdown")
  return frame
end

windows.layout = layout
-----------------------------

return windows
