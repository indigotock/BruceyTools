local slider = {}

function slider:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile('btools/gui/forms.xml')
end

function constructor(self, container, defaults)
  if slider.xmlDoc == nil then
    slider.xmlDoc = XmlDoc.CreateFromFile('btools/gui/forms.xml')
  end
  local obj = {}
  setmetatable(obj,{__index = slider})

  defaults = defaults or {}
  obj.sClass = "slider"

  obj.cControl = Apollo.LoadForm(slider.xmlDoc, obj.sClass, container, obj)
  obj.nMinValue = defaults.nMinValue or 1
  obj.nMaxValue = defaults.nMaxValue or 100
  obj.nTickAmount = defaults.nTickAmount or 1

  obj.fValueMod = defaults.fValueMod or function(v) return v end
  obj.fChangeCallback = defaults.fChangeCallback or function(v) end

  obj.cControl:FindChild('text_header'):SetText(defaults.sHeader or "")
  obj.cControl:FindChild('slider_control'):AddEventHandler("SliderBarChanged","event_slider_change",obj)
  obj.cControl:FindChild('slider_control'):SetMinMax(obj.nMinValue,obj.nMaxValue)
  obj.cControl:FindChild('slider_control'):SetValue(defaults.nInitialValue or obj.nMinValue)
  obj.cControl:FindChild('text_value'):SetText(tostring(obj.fValueMod(obj.cControl:FindChild('slider_control'):GetValue())))
  return obj
end

function slider:event_slider_change()
  self.cControl:FindChild('text_value'):SetText(tostring(self.fValueMod(self.cControl:FindChild('slider_control'):GetValue())))
  self.fChangeCallback(self.cControl:FindChild('slider_control'):GetValue())
end

function slider:get_value()
  return self.cControl:FindChild('slider_control'):GetValue()
end

setmetatable(slider,{__call=constructor})

Apollo.RegisterPackage(slider,'indigotock.btools.gui.slider',1,{})