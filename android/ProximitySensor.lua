local s=createSensor('CM3602 PROXIMITY SENSOR', 'TYPE_PROXIMITY')
--[[
function s:update()
  self.state={math.random(0, 360), math.random(-180, 180), math.random(-90, 90)}
end
--]]
