local colour_picker = {}

function colour_picker:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile('brucey-tools/gui/forms.xml')
end

function constructor(self, container, defaults)
  if colour_picker.xmlDoc == nil then
    colour_picker.xmlDoc = XmlDoc.CreateFromFile('brucey-tools/gui/forms.xml')
  end
  local obj = {}
  setmetatable(obj,{__index = colour_picker})

  defaults = defaults or {}
  obj.sClass = "colour_picker"

  obj.cControl = Apollo.LoadForm(colour_picker.xmlDoc, obj.sClass, container, obj)
  return obj
end

function colour_picker:get_value()
  return {}
end

setmetatable(colour_picker,{__call=constructor})

Apollo.RegisterPackage(colour_picker,'indigotock.btools.gui.colour_picker',1,{})
