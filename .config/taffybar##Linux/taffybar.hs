import System.Taffybar 
import System.Taffybar.Systray
import System.Taffybar.Battery
import System.Taffybar.TaffyPager
import System.Taffybar.SimpleClock
import Data.List

main = do
   let cfg = defaultTaffybarConfig { barHeight = 20
                                   }
       clock = textClockNew Nothing "<span color='red'>%a %b %_d %H:%M</span>" 1
       bat = batteryBarNew defaultBatteryConfig 30
       pager = taffyPagerNew defaultPagerConfig
       tray = systrayNew

   defaultTaffybar cfg {
                         startWidgets = [ pager ]
                       , endWidgets = reverse [ bat, tray, clock ]
                       }
