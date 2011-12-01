lg=love.graphics
W,H=lg:getWidth(), lg:getHeight()
local Pong=require 'Pong'
local Vector=require 'Vector'

HEADING, PITCH, ROLL=0,0,0

gMySensors={}

function love.load ()
  PONG=Pong(W, H)
	if not love.phone then
    require 'androlove'
  end
	if (love.phone) then
		-- orientation fixed for testing orientation sensor
		--love.phone.setRequestedOrientation(love.phone.SCREEN_ORIENTATION.SCREEN_ORIENTATION_LANDSCAPE)
		love.phone.setRequestedOrientation(love.phone.SCREEN_ORIENTATION.SCREEN_ORIENTATION_PORTRAIT)
		
		-- sensors
		for k,sensor in ipairs(love.phone.getSensorList(love.phone.SENSOR_TYPE.TYPE_ALL)) do 
			gMySensors[sensor:getLoveSensorID()] = sensor
			local name = string.lower(sensor:getName())
			--~ if (string.find(name,"accel")) then 
			if (string.find(name,"orientation")) then 
				local rate = 1
				love.phone.registerSensorListener(sensor,rate)
			end
		end
		
		-- sensor callback
		function love.phone.sensorevent(action,data) 
      HEADING=data[1] or 0
      PITCH=data[2] or 0
      ROLL=data[3] or 0
      PONG:setAcceleration(Vector(-ROLL, 0))
		end
		
		-- touch events
		--love.phone.enableTouchEvents()
	else
		print("needs love-android love.phone api")
	end
end


L=math.min(W, H)/2
function love.draw ()
  PONG:draw()
  lg.setColor({255,255,255,255})
	lg.print(string.format('HEADING %d', HEADING),10,10)
	lg.print(string.format('PITCH %d', PITCH),10,30)
	lg.print(string.format('ROLL %d', ROLL),10,50)

end

function love.update (dt)
  if love.phone.update then
    love.phone.update(dt)
  end
  PONG:update(dt)
end
