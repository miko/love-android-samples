local s=createSensor('AK8973 3-AXIS MAGNETIC FIELD SENSOR', 'TYPE_MAGNETIC_FIELD')
--[[
function s:update()
  self.state={math.random(0, 360), math.random(-180, 180), math.random(-90, 90)}
end
--]]
