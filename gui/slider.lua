local slider = {}

function slider:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile('btools/gui/forms.xml')
end

function constructor(self, container, defaults)
  local obj = {}
  setmetatable(obj,{__index = slider})

  defaults = defaults or {}
  obj.sClass = "slider"

  -- Initialisation here

  return obj
end

setmetatable(slider,{__call=constructor})

Apollo.RegisterPackage(slider,'indigotock.btools.gui.slider',1,{})