local drop_button = {}

function drop_button:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile('btools/gui/forms.xml')
end


drop_button.cEnabledColour = ApolloColor.new('UI_TextHoloBodyHighlight')
drop_button.cDisabledColour = ApolloColor.new('UI_BtnTextBlueDisabled')

function constructor(self, container, defaults)
  if drop_button.xmlDoc == nil then
    drop_button.xmlDoc = XmlDoc.CreateFromFile('btools/gui/forms.xml')
  end
  local obj = {}
  setmetatable(obj,{__index = drop_button})

  defaults = defaults or {}
  obj.sClass = "drop_button"
  
  obj.nWindowWidth = defaults.nWindowWidth or 250
  obj.nWindowHeight = defaults.nWindowHeight or 250

  obj.sText = defaults.sText or "Button"

  obj.cControl = Apollo.LoadForm(obj.xmlDoc, obj.sClass, container, obj)
  obj.cButton = obj.cControl:FindChild("Button")
  obj.cWindow  = obj.cControl:FindChild("DropWindow")
  obj.cContainer = obj.cControl:FindChild("ContentContainer")

  obj.cButton:AttachWindow(obj.cWindow)

  obj.cWindow:Show(false,true)
  obj.cButton:SetText(obj.sText)
  obj:update_window()

  return obj
end

function drop_button:update_window()
  self.cWindow:SetAnchorOffsets(
    -(55+self.nWindowWidth/2),
    10,
    55+self.nWindowWidth/2,
    55+self.nWindowHeight)
end

function drop_button:set_content(xDoc, sForm, tHandler)
  return Apollo.LoadForm(xDoc, sForm, self.cContainer, tHandler or self)
end

setmetatable(drop_button,{__call=constructor})

Apollo.RegisterPackage(drop_button,'indigotock.btools.gui.drop_button',1,{})
