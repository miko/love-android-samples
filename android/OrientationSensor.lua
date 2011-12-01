local s=createSensor('AK8973 ORIENTATION SENSOR', 'TYPE_ORIENTATION')
function s:update()
  self.state={math.random(0, 360), math.random(-180, 180), math.random(-90, 90)}
end

--[[
function s:getState()
  return __RIDS[''], self.state
end
--]]
