require 'class'
local Vector=require 'Vector'
lg=love.graphics

local M=class(function(self, W, H)
  self.Pad={pos=Vector(W/2, H-20), velocity=Vector(0,0), size=math.min(350, W/2), acceleration=Vector(0,0)}
  self.Pad.size=W/5
  self.W=W
  self.H=H
  self.fail=false
  self:reset()
end)

function M:setAcceleration(a)
  self.Pad.acceleration=a
end

function M:reset(dt)
  self.Ball={pos=Vector(W/2, H/2), velocity=Vector(math.random(10)-5,-math.random(5)-5)}
  --self.Pad.pos=Vector(W/2, H-20)
  self.Pad.velocity=Vector(0,0)
  self.Pad.acceleration=Vector(0,0)
  self.score=0
end

function M:update(dt)
  if self.fail then
    self.fail=self.fail-dt
    if self.fail<=0 then
      self.fail=false
      self:reset()
    end
    return
  end
  local ball=self.Ball
  local bpos, bvelocity=ball.pos, ball.velocity
  local newpos=bpos+bvelocity*dt
  if bvelocity.x<0 and newpos.x<0 then
    bvelocity.x=-bvelocity.x
  end
  if bvelocity.x>0 and newpos.x>self.W then
    bvelocity.x=-bvelocity.x
  end
  if bvelocity.y<0 and newpos.y<0 then
    bvelocity.y=-bvelocity.y
  end
  if bvelocity.y>0 and newpos.y>self.H then
    bvelocity.y=-bvelocity.y
  end
  ball.pos=bpos+bvelocity

  local pad=self.Pad
  pad.velocity=pad.velocity+pad.acceleration*dt

  local ppos, pvelocity=pad.pos, pad.velocity
  local newpos=ppos+pvelocity
  if pvelocity.x<0 and newpos.x<0 then
    pvelocity.x=0
    pad.acceleration.x=0
    pad.pos.x=0
  end
  if pvelocity.x>0 and newpos.x>self.W-pad.size then
    pvelocity.x=0
    pad.acceleration.x=0
    pad.pos.x=self.W-pad.size
  end
  pad.pos=ppos+pvelocity

  if bpos.y>=ppos.y-10 then
    if bpos.x>=ppos.x and bpos.x<=ppos.x+pad.size then
      ball.velocity.y=-ball.velocity.y
      ball.pos=bpos+ball.velocity
      self.score=self.score+1
    else
      self.fail=2
    end
  end
end

function M:draw()
	lg.setBackgroundColor({0,0,0,255})
  lg.setColor(255,255,255,255)
  lg.print("Score: "..self.score, self.W/2, 5)
  lg.setLineWidth(5)
  lg.line(0,self.H, 0,0, self.W,0, self.W,self.H)

  --[[
	lg.print(string.format('HEADING %d', HEADING),10,10)
	lg.print(string.format('PITCH %d', PITCH),10,30)
	lg.print(string.format('ROLL %d', ROLL),10,50)
  --]]

  lg.rectangle('fill', self.Pad.pos.x, self.Pad.pos.y, self.Pad.size, 10)
  lg.setColor(255,0,0)
  lg.circle('fill', self.Ball.pos.x, self.Ball.pos.y, 10, 10)

  if self.fail then
    lg.print("FAILED", self.W/3, self.H/2)
  end

end

return M
