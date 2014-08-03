local slider = {}

function slider:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile('brucey-tools/gui/forms.xml')
end

function constructor(self, container, defaults)
  if slider.xmlDoc == nil then
    slider.xmlDoc = XmlDoc.CreateFromFile('brucey-tools/gui/forms.xml')
  end
  local obj = {}
  setmetatable(obj,{__index = slider})

  defaults = defaults or {}
  obj.sClass = "slider"

  obj.cControl = Apollo.LoadForm(slider.xmlDoc, obj.sClass, container, obj)
  obj.nMinValue = defaults.nMinValue or 0
  obj.nMaxValue = defaults.nMaxValue or 100
  obj.nTickAmount = defaults.nTickAmount or 1
  obj.nInitialValue = defaults.nInitialValue or 50

  obj.fValueMod = defaults.fValueMod or function(v) return v end

  obj.cControl:FindChild('slider_control'):AddEventHandler("SliderBarChanged","slider_change",obj)

  return obj
end

function slider:slider_change(cHandler, cControl, nValue)
  obj.cControl:FindChild('text_value'):SetText(tostring(self.fValueMod(nValue)))
  Print('change')
end

setmetatable(slider,{__call=constructor})

Apollo.RegisterPackage(slider,'indigotock.btools.gui.slider',1,{})