-- My xmonad config

-- useful
import System.IO
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad

-- actions
import XMonad.Actions.GridSelect 
import XMonad.Actions.Volume -- amixer interface
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Actions.UpdatePointer

-- layouts
import XMonad.Layout.Fullscreen hiding (fullscreenEventHook) --ewmh provides this hook
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace

-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops

-- utils
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Util.Run (spawnPipe, safeSpawn, safeSpawnProg)
import XMonad.Util.NamedScratchpad

-- For XF86* media keys
import Graphics.X11.ExtraTypes.XF86

-- for logTitles function (see below)
import Control.Monad (liftM, liftM2, sequence)
import XMonad.Util.NamedWindows (getName, unName)
import XMonad.Util.Loggers
import Data.List (intercalate)
--

-- for taffybar
import System.Taffybar.Hooks.PagerHints (pagerHints)
--import DBus.Client
--import System.Taffybar.XMonadLog (dbusLogWithPP,taffybarDefaultPP,taffybarColor)
--
------------------------------------------------------------------------
-- Certain helpful programs
myTerminal = "termite"
myRofi = "rofi"
myRofiOpts = ["--combi-modi", "run,window,ssh", "-show", "combi"]
myCapture = "maim"
myCaptureDefaults = ["-s", "~/Screenshots/$(date +s).png"]
myLock = "xscreensaver-command"
myLockOptions = ["-lock"]
--myFont = "xft:Anonymous Pro-12:antialias=false:autohint=false"
myFont = "xft:Anonymous Pro-12"
------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
myWorkspaces = ["1:web","2:im","3:term","4:code", "5:misc"]
 
------------------------------------------------------------------------
-- Scratchpads
scratchpads = [
    NS "ranger" (myTerminal ++ " -e ranger -t ranger") (iconName =? "ranger") center ,
    NS "notes" "gvim --role notes ~/notes.txt" (role =? "notes") nonFloating
 ] where 
     role = stringProperty "WM_WINDOW_ROLE"
     iconName = stringProperty "WM_ICON_NAME"
     center = customFloating $ W.RationalRect l t w h 
       where
         h = 0.5
         w = 0.5
         t = 0.25
         l = 0.25
------------------------------------------------------------------------
-- Window rules
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
myManageHook = composeOne . concat $
    [ 
    [isDialog <&&> className =? x -?> doFloat | x <- myIgnores]
    , [isFullscreen   -?> (doF W.focusDown <+> doFullFloat)]
    , [className =? c -?> doCenterFloat | c <- myCFloats]
    , [title =? t     -?> doCenterFloat | t <- myTFloats]
    , [resource =? r  -?> doFloat | r <- myRFloats]
    , [resource =? i  -?> doIgnore | i <- myIgnores]
    , [(className =? x <||> title =? x <||> resource =? x) -?> doShift "1:web" | x <- my1Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) -?> doShift "2:im" | x <- my2Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) -?> doShift "3:term" | x <- my3Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) -?> doShift "4:code" | x <- my4Shifts]
    ] 
    where
      myCFloats = ["MPlayer", "XCalc", "Arandr", "Xmessage", "Wicd-client.py"]
      myTFloats = ["Downloads", "Save As..."]
      myRFloats = []
      myIgnores = ["jetbrains-idea"]
      my1Shifts = ["Google-chrome", "Firefox", "Firefox-dev", "chromium-browser"]
      my2Shifts = ["skype", "Telegram"]
      my3Shifts = ["urxvt", "st", "Alacritty", "termite"]
      my4Shifts = ["jetbrains-idea"]

------------------------------------------------------------------------
-- Layouts
--
-- All but myNoBorders have avoidStruts modifier to prevent overlapping
-- the bar

myLayout = onWorkspace "1:web" myFull 
           $ onWorkspace "2:im" myTall 
           $ onWorkspace "3:term" (myTallHalf ||| myTabbed)
           $ onWorkspace "5:ide" (myFull ||| myNoBorders)
           $ onWorkspace "9" myNoBorders
           $ standardLayouts
    where
       standardLayouts = myTallHalf ||| myTabbed ||| myFull ||| myNoBorders 
       -- number of master windows + resize step + master window size
       myTallHalf = avoidStruts $ Tall 1 (3/100) (1/2)
       myTall     = avoidStruts $ Tall 1 (3/100) (0.8)
       myTabbed = avoidStruts $ tabbed shrinkText tabConfig
       myFull = avoidStruts $ smartBorders Full
       myNoBorders = smartBorders Full

------------------------------------------------------------------------
-- Colors and borders
--
myNormalBorderColor  = "#7C7C7C"
myFocusedBorderColor = "#009900"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = myNormalBorderColor
    , activeTextColor = myFocusedBorderColor
    , activeColor = "#000000"
    , inactiveBorderColor = "#7C7C7C"
    , inactiveTextColor = "#EEEEEE"
    , inactiveColor = "#000000"
    , fontName = myFont
}

-- Width of the window border in pixels.
myBorderWidth = 1

------------------------------------------------------------------------
-- Key bindings
--
myModMask = mod4Mask

mydefaultChannels :: [String]
mydefaultChannels = ["Master", "Wave", "PCM", "Headphone"]


myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --

  -- Start a terminal.  Terminal to start is specified by myTerminal variable.
  [ ((modMask , xK_Return), safeSpawn myTerminal [])

  -- Lock the screen using xscreensaver.
  , ((modMask , xK_F12), spawn "slock")

  -- Launch prompt
  , ((modMask, xK_p), safeSpawn myRofi myRofiOpts)

  -- Toggle doc gaps
  , ((modMask, xK_b     ), sendMessage ToggleStruts)

  -- Toggle ranger
  , ((modMask, xK_s), namedScratchpadAction scratchpads "ranger")
  --------------------------------------------------------------------
  -- Support of Fn keys
  -- Fn+F3
  , ((0, xF86XK_ScreenSaver), safeSpawn myLock myLockOptions)
  -- Fn+F6
  , ((0, xF86XK_WebCam), safeSpawn myCapture myCaptureDefaults)
  -- Fn+F8
  , ((0, xF86XK_MonBrightnessUp), safeSpawn "xbacklight" ["-inc", "10"])
  -- Fn+F9
  , ((0, xF86XK_MonBrightnessDown), safeSpawn "xbacklight" ["-dec", "10"])
  , ((0, xF86XK_AudioMute), toggleMuteChannels mydefaultChannels  >> return ())
  , ((0, xF86XK_AudioLowerVolume), lowerVolume 3 >> return ())
  , ((0, xF86XK_AudioRaiseVolume), raiseVolume 3 >> return ())
 --------------------------------------------------------------------
  -- "Standard" xmonad key bindings
  --

  -- Close focused window.
  , ((modMask .|. shiftMask, xK_c), kill)

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space), sendMessage NextLayout)

  -- Resize viewed windows to the correct size.
  , ((modMask, xK_n), refresh)

  -- Move focus to the next window.
  , ((modMask, xK_Tab), windows W.focusDown)

  -- Move focus to the next window.
  , ((modMask, xK_j), windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_k), windows W.focusUp  )

  -- Move focus to the master window.
  , ((modMask, xK_m), windows W.focusMaster  )

  -- Swap the focused window and the master window.
  , ((modMask .|. shiftMask, xK_Return), windows W.swapMaster)

  -- Shrink the master area.
  , ((modMask, xK_h), sendMessage Shrink)

  -- Expand the master area.
  , ((modMask, xK_l), sendMessage Expand)

  -- Increment the number of windows in the master area.
  , ((modMask, xK_comma), sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((modMask, xK_period), sendMessage (IncMasterN (-1)))

  -- Quit xmonad.
  , ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))

  -- Restart xmonad.
  , ((modMask .|. controlMask, xK_r), 
         spawn "xmonad --recompile && xmonad --restart")
  ]
  ++
 
  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
  ++

  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
 
 
------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
 
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
  [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
 
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
 
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]
 

------------------------------------------------------------------------
-- Startup hook
--
myStartupHook = do
    setWMName "LG3D"
    safeSpawn "polybar" ["default"]
    
------------------------------------------------------------------------
-- logTitles funtion, to pass all windows in current workspace (and not
-- only focused one) to the bar
-- 
-- taken from:
-- https://bbs.archlinux.org/viewtopic.php?id=123299
--
logTitles :: (String -> String) -> Logger
logTitles ppFocus =
        let
          windowTitles windowset = sequence (map (fmap showName . getName) (W.index windowset))
            where
              fw = W.peek windowset
              showName nw =
                let
                  window = unName nw
                  name = shorten 50 (show nw)
                in
                  if maybe False (== window) fw
                    then
                      ppFocus name
                    else
                      name
        in
          withWindowSet $ liftM (Just . (intercalate " | ")) . windowTitles

------------------------------------------------------------------------
-- TaffyBar configuration
-- https://hackage.haskell.org/package/taffybar
--taffybarPP = taffybarDefaultPP 
--                  { ppCurrent = taffybarColor "green" "" . wrap "[" "]" 
--                  , ppTitle   = const ""
--                  , ppVisible = wrap "(" ")"
--                  , ppUrgent  = taffybarColor "red" "yellow"
--                  , ppExtras  = [logTitles (taffybarColor "green" "")]
--                  , ppLayout = const ""
--                  } 

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--


main = do
--  client <- connectSession
  xmonad $ ewmh $ pagerHints myDefaults 
  --xmonad $ ewmh myDefaults 
--main = xmonad =<< statusBar myBar myPP toggleStrutsKey myDefaults
--myBar = "xmobar"
--myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }
--toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_B)


------------------------------------------------------------------------
-- Xmonad default configuration, overriden by custom values in this file
-- 
myDefaults = defaultConfig {
    -- simple stuff
    terminal             = myTerminal
    , focusFollowsMouse  = myFocusFollowsMouse
    , borderWidth        = myBorderWidth
    , modMask            = myModMask
    , workspaces         = myWorkspaces
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
 
    -- bindings
    , keys               = myKeys
    , mouseBindings      = myMouseBindings
 
    -- hooks, layouts
    , layoutHook         = smartBorders $ myLayout
    , manageHook         = fullscreenManageHook <+> manageDocks <+> myManageHook <+> namedScratchpadManageHook scratchpads
    , startupHook        = myStartupHook
    , handleEventHook    = docksEventHook <+> fullscreenEventHook
}
