local utils = {}

-- https://github.com/joemiller/dotfiles/blob/master/_hammerspoon/utils.lua
-- utils.connectTunnelBlickVPN() - Use applescript to tell the running Tunnelblick
-- instance to try to connect to a VPN. The name of the VPN should match what is shown
-- in Tunnelblick's menu.
--
function utils.connectTunnelblickVPN(vpnName)
    hs.notify.new( {title="Hammerspoon", subTitle="Starting VPN connection to " .. vpnName} ):send()
    return hs.osascript.applescript(
        string.format('tell application "Tunnelblick" \
                        connect "%s" \
                      end tell', vpnName)
    )
end

-- utils.disconnectTunnelblickVPNs - disconnect all connected tunnelblick VPNs
--
function utils.disconnectTunnelblickVPNs()
    return hs.osascript.applescript(
        'tell application "Tunnelblick" \
           disconnect all \
         end tell'
    )
end

return utils        
