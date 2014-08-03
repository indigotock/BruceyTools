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

  obj.cControl = Apollo.LoadForm(obj.xmlDoc, obj.sClass, container, obj)
  

  return obj
end

setmetatable(slider,{__call=constructor})

Apollo.RegisterPackage(slider,'indigotock.btools.gui.slider',1,{})