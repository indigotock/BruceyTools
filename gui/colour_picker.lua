local colour_picker = {}

function colour_picker:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile('brucey-tools/gui/forms.xml')
end

local function toHex(num) 
     local hexstr = '0123456789abcdef' 
     local s = '' 
     while num > 0 do 
         local mod = math.fmod(num, 16) 
         s = string.sub(hexstr, mod+1, mod+1) .. s 
         num = math.floor(num / 16) 
     end 
     if s == '' then s = '00' end 
     if #s == 1 then s = '0'..s end
     return s 
 end

function constructor(self, container, defaults)
  if colour_picker.xmlDoc == nil then
    colour_picker.xmlDoc = XmlDoc.CreateFromFile('brucey-tools/gui/forms.xml')
  end
  local obj = {}
  setmetatable(obj,{__index = colour_picker})

  defaults = defaults or {}
  obj.sClass = "colour_picker"
  obj.fCallback = defaults.fCallback or function() end
  obj.values = {}
  obj.values.r = defaults.nRedValue or 0
  obj.values.g = defaults.nGreenValue or 0
  obj.values.b = defaults.nBlueValue or 0
  
  local sc = Apollo.GetPackage('indigotock.btools.gui.slider').tPackage

  obj.cControl = Apollo.LoadForm(colour_picker.xmlDoc, obj.sClass, container, obj)
  obj.cRedSlider = sc(obj.cControl:FindChild('red_slider'), {sHeader = 'Red: ', nMinValue = 0, nMaxValue = 255, nInitialValue = obj.values.r,
    fChangeCallback = function(val) obj.values.r = val obj:callback() end})
  obj.cBlueSlider = sc(obj.cControl:FindChild('blue_slider'), {sHeader = 'Green: ', nMinValue = 0, nMaxValue = 255, nInitialValue = obj.values.g,
    fChangeCallback = function(val) obj.values.g = val obj:callback() end})
  obj.cGreenSlider = sc(obj.cControl:FindChild('green_slider'), {sHeader = 'Blue: ', nMinValue = 0, nMaxValue = 255, nInitialValue = obj.values.b,
    fChangeCallback = function(val) obj.values.b = val obj:callback() end})


  obj:callback()
  return obj
end

function colour_picker:callback()
  local hexVal = 'ff'..toHex(self.values.r)..toHex(self.values.g)..toHex(self.values.b)
  self.cControl:FindChild('colour_indicator'):SetBGColor(hexVal)
  self.fCallback(hexVal)
end

function colour_picker:get_value()
  return {}
end

setmetatable(colour_picker,{__call=constructor})

Apollo.RegisterPackage(colour_picker,'indigotock.btools.gui.colour_picker',1,{})
