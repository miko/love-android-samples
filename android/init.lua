print('ANDROLIB READ IN')
__IDS, __RIDS={},{}
local STATE={SENSORS={}, REGISTEREDSENSORS={}, DOWN={}, BLOCKKEY={}}
local MT_SENSOR={
  getName=function(self)
    return self.name or 'UnNamed'
  end,
  getType=function(self)
    return self.type or 'UnTyped'
  end,
  getLoveSensorID=function(self)
    return self.id or 1
  end,
  onAccuracyChanged=function(self, accuracy)
    self.accuracy=self.accuracy
  end,
  onSensorChanged=function(self, event)
    self.accuracy=self.accuracy
    love.phone.sensorevent(self:getLoveSensorID(), event )
  end,
  getMaximumRange=function(self)
    return self.maximumrange or 0
  end,
  getMinDelay=function(self)
    return self.mindelay or 0
  end,
  getPower=function(self)
    return self.power or 0
  end,
  getResolution=function(self)
    return self.resolution or 0
  end,
  getVendor=function(self)
    return self.vendor or 'LoveAndroid'
  end,
  getVersion=function(self)
    return self.version or 1
  end,
  __tostring=function(self)
    return '<Sensor: '..self:getName()..':'..self:getType()..'>'
  end,
  update=function(self)
    self.state={math.random(10), math.random(10),math.random(10)}
  end,
  getState=function(self)
    return __RIDS['ACTION_MOVE'], self.state
  end,
}
MT_SENSOR.__index=MT_SENSOR

function createSensor(name, type)
  local s=setmetatable({name=name, type=type, id=#STATE.SENSORS+1}, MT_SENSOR)
  table.insert(STATE.SENSORS, s)
  return s
end

local function registerSensor(sensor, rate)
  table.insert(STATE.REGISTEREDSENSORS, {sensor=sensor, rate=rate, elapsed=0})
end

local function _nextid(var)
  __ID=(__ID or 0)+1
  __IDS[__ID]=var
  __RIDS[var]=__ID
  return __ID
end


love.phone={
  SCREEN_ORIENTATION={
    SCREEN_ORIENTATION_PORTRAIT=_nextid('SCREEN_ORIENTATION_PORTRAIT'),
    SCREEN_ORIENTATION_LANDSCAPE=_nextid('SCREEN_ORIENTATION_LANDSCAPE'),
    SCREEN_ORIENTATION_BEHIND=_nextid('SCREEN_ORIENTATION_BEHIND'),
    SCREEN_ORIENTATION_FULL_SENSOR=_nextid('SCREEN_ORIENTATION_FULL_SENSOR'),
    SCREEN_ORIENTATION_SENSOR_LANDSCAPE=_nextid('SCREEN_ORIENTATION_SENSOR_LANDSCAPE'),
    SCREEN_ORIENTATION_SENSOR_PORTRAIT=_nextid('SCREEN_ORIENTATION_SENSOR_PORTRAIT'),
    SCREEN_ORIENTATION_UNSPECIFIED=_nextid('SCREEN_ORIENTATION_UNSPECIFIED'),
    SCREEN_ORIENTATION_USER=_nextid('SCREEN_ORIENTATION_USER'),
    SCREEN_ORIENTATION_NOSENSOR=_nextid('SCREEN_ORIENTATION_NOSENSOR'),
  },
  SENSOR_TYPE={
    TYPE_ALL=_nextid('TYPE_ALL'),
    TYPE_ACCELEROMETER=_nextid('TYPE_ACCELEROMETER'),
    TYPE_AMBIENT_TEMPERATURE=_nextid('TYPE_AMBIENT_TEMPERATURE'),
    TYPE_GRAVITY=_nextid('TYPE_GRAVITY'),
    TYPE_GYROSCOPE=_nextid('TYPE_GYROSCOPE'),
    TYPE_LIGHT=_nextid('TYPE_LIGHT'),
    TYPE_LINEAR_ACCELERATION=_nextid('TYPE_LINEAR_ACCELERATION'),
    TYPE_MAGNETIC_FIELD=_nextid('TYPE_MAGNETIC_FIELD'),
    TYPE_ORIENTATION=_nextid('TYPE_ORIENTATION'),
    TYPE_PRESSURE=_nextid('TYPE_PRESSURE'),
    TYPE_PROXIMITY=_nextid('TYPE_PROXIMITY'),
    TYPE_RELATIVE_HUMIDITY=_nextid('TYPE_RELATIVE_HUMIDITY'),
    TYPE_ROTATION_VECTOR=_nextid('TYPE_ROTATION_VECTOR'),
  },
  MOTION_EVENT_ACTION_TYPE={
    ACTION_CANCEL=_nextid('ACTION_CANCEL'),
    ACTION_DOWN=_nextid('ACTION_DOWN'),
    ACTION_MASK=_nextid('ACTION_MASK'),
    ACTION_MOVE=_nextid('ACTION_MOVE'),
    ACTION_OUTSIDE=_nextid('ACTION_OUTSIDE'),
    ACTION_POINTER_1_DOWN=_nextid('ACTION_POINTER_1_DOWN'),
    ACTION_POINTER_1_UP=_nextid('ACTION_POINTER_1_UP'),
    ACTION_POINTER_2_DOWN=_nextid('ACTION_POINTER_2_DOWN'),
    ACTION_POINTER_2_UP=_nextid('ACTION_POINTER_2_UP'),
    ACTION_POINTER_3_DOWN=_nextid('ACTION_POINTER_3_DOWN'),
    ACTION_POINTER_3_UP=_nextid('ACTION_POINTER_3_UP'),
    ACTION_POINTER_DOWN=_nextid('ACTION_POINTER_DOWN'),
    ACTION_POINTER_ID_MASK=_nextid('ACTION_POINTER_ID_MASK'),
    ACTION_POINTER_ID_SHIFT=_nextid('ACTION_POINTER_ID_SHIFT'),
    ACTION_POINTER_UP=_nextid('ACTION_POINTER_UP'),
    ACTION_UP=_nextid('ACTION_UP'),
  },
  FEEDBACK_CONSTANT={
    FLAG_IGNORE_GLOBAL_SETTING=_nextid('FLAG_IGNORE_GLOBAL_SETTING'),
    FLAG_IGNORE_VIEW_SETTING=_nextid('FLAG_IGNORE_VIEW_SETTING'),
    KEYBOARD_TAP=_nextid('KEYBOARD_TAP'),
    LONG_PRESS=_nextid('LONG_PRESS'),
    VIRTUAL_KEY=_nextid('VIRTUAL_KEY'),

  }
}

function love.phone.newResourceImage(resId)
  error('Not implemented')
end
function love.phone.newResourceAudioSource(resId, atype)
  atype=atype or 'static'
  error('Not implemented')
end
function love.phone.getPackageName()
  return 'DefaultPackageName'
end
function love.phone.getResourceName()
  return 'DefaultResourceName'
end
function love.phone.getResourceId(name, type, package)
  error('Not implemented')
end


function love.phone.setRequestedOrientation(o)
  print('Setting orientation: ',o, __IDS[o])
  if not o then
    error('Unknown orientation!')
  end
end
function love.phone.getSensorList(o)
  local sensors={}
  for k,v in ipairs(STATE.SENSORS) do
    if o==__RIDS['TYPE_ALL'] or o==v.type then
      sensors[#sensors+1]=v
    end
  end
  return sensors
end
function love.phone.getDefaultSensor(o)
  for k,v in ipairs(STATE.SENSORS) do
    if o==__RIDS['TYPE_ALL'] or o==v.type then
      return v
    end
  end
end
function love.phone.enableTouchEvents(...)
  STATE.touchEvents=true
end
function love.phone.registerSensorListener(sensor, rate)
  print('Register: ', sensor, rate)
  registerSensor(sensor, rate)
end
function love.phone.setBlockMainKey_Back(status)
  STATE.BLOCKKEY['back']=status and status or nil
end
function love.phone.setBlockMainKey_Menu(status)
  STATE.BLOCKKEY['menu']=status and status or nil
end
function love.phone.setBlockMainKey_Search(status)
  STATE.BLOCKKEY['search']=status and status or nil
end
function love.phone.setHapticFeedbackEnabled(status)
  STATE.HapticFeedback=status and status or nil
end
function love.phone.performHapticFeedback(c)
  print('HAPTIC FEEDBACK:', c)
end

local rand=math.random
local W,H=love.graphics.getWidth(), love.graphics.getHeight()
local isDown=love.keyboard.isDown
function love.phone.update(dt)
  if STATE.touchEvents==true and love.phone.touch then
    if rand(100)>95 then
      STATE.TOUCHID=(STATE.TOUCHID or 0)+1
      love.phone.touch(__RIDS['ACTION_MOVE'], {STATE.TOUCHID, rand(W),rand(H)})
    end
  end
  if love.phone.sensorevent then
    for k,v in ipairs(STATE.REGISTEREDSENSORS) do
      v.elapsed=v.elapsed+dt
      if v.elapsed>=v.rate then
        v.elapsed=v.elapsed-v.rate
        v.sensor:update()
        love.phone.sensorevent(v.sensor:getState())
      end
    end
  end
  if love.phone.main_key_event then
    -- HOME
    if isDown('f1') then
      if not STATE.DOWN['home'] then
        love.phone.main_key_event('home')
        love.phone.main_key_event('leavehint')
        STATE.DOWN['home']=true
      end
    else
      STATE.DOWN['home']=nil
    end
    -- MENU
    if isDown('f2') then
      if not STATE.DOWN['menu'] then
        love.phone.main_key_event('menu')
        STATE.DOWN['menu']=true
      end
    else
      STATE.DOWN['menu']=nil
    end
    -- BACK
    if isDown('f3') then
      if not STATE.DOWN['back'] then
        love.phone.main_key_event('back')
        STATE.DOWN['back']=true
      end
    else
      STATE.DOWN['back']=nil
    end
    -- SEARCH
    if isDown('f4') then
      if not STATE.DOWN['search'] then
        love.phone.main_key_event('search')
        STATE.DOWN['search']=true
      end
    else
      STATE.DOWN['search']=nil
    end

  end
end

require 'android.AccelerometerSensor'
require 'android.MagneticFieldSensor'
require 'android.OrientationSensor'
require 'android.ProximitySensor'
require 'android.LightSensor'

