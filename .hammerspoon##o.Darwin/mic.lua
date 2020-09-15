local muteCircle = nil
function removeCircle(circle)
  if circle then
    circle:delete()
  end
end

function createMuteCircle()
  muteCircle = hs.drawing.circle(hs.geometry.rect(20, 40, 80, 80))
  muteCircle:setFillColor({["red"]=0, ["green"]=0, ["blue"]=0, ["alpha"]=0.5})
  muteCircle:setFill(true)
  muteCircle:setStroke(true)
end

function drawMuteCircle()
  removeCircle(muteCircle)
  createMuteCircle()
  muteCircle:show()
end

----
-- source: https://github.com/squaresurf/hammerspoon-castle/blob/master/home/.hammerspoon/init.lua#L70-L95

function micIsMuted()
  local mic = hs.audiodevice.defaultInputDevice()
  return mic:muted()
end

function displayIfMicIsMuted()
    muted = micIsMuted()
    if muted == nil then
        hs.alert.show("Not sure if the Mic is muted.")
    elseif muted then
      drawMuteCircle()
    else
      removeCircle(muteCircle)
    end
end

-- Toggle mic mute
function muteMic()
  local mic = hs.audiodevice.defaultInputDevice()
  mic:setMuted(true)
end

function unmuteMic()
  local mic = hs.audiodevice.defaultInputDevice()
  mic:setMuted(false)
end

function toggleMicMute()
    muted = micIsMuted()
    if muted then
      unmuteMic()
    else
      muteMic()
    end
    displayIfMicIsMuted()
end
