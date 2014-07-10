local number_ticker = {}

function number_ticker:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile('btools/gui/forms.xml')
end


number_ticker.cEnabledColour = ApolloColor.new('UI_TextHoloBodyHighlight')
number_ticker.cDisabledColour = ApolloColor.new('UI_BtnTextBlueDisabled')

function constructor(self, container, defaults)
  if number_ticker.xmlDoc == nil then
    number_ticker.xmlDoc = XmlDoc.CreateFromFile('btools/gui/forms.xml')
  end
  local obj = {}
  setmetatable(obj,{__index = number_ticker})

  defaults = defaults or {}
  obj.sClass = "number_ticker"
  obj.nDefaultValue = defaults.nDefaultValue or 1
  obj.nIncrementValue = defaults.nIncrementValue or 0.5
  obj.sHeaderText = defaults.sHeaderText or "Item"

  obj.tData = defaults.tData or {}

  obj.cControl = Apollo.LoadForm(obj.xmlDoc, 'number_ticker', container, obj)
  obj.cControl:SetData(obj)
  obj.cHeaderBox = obj.cControl:FindChild("ItemHeader")
  obj.cAddBtn = obj.cControl:FindChild("AddBtn")
  obj.cSubtractBtn = obj.cControl:FindChild("SubtractBtn")
  obj.cEditBox = obj.cControl:FindChild("EditBox")

  obj.fOnChangeValue = defaults.fOnChangeValue or function(ticker, newVal) end

  if defaults.nWidth then
    local l,t,r,b = obj.cControl:GetAnchorPoints()
    obj.cControl:SetAnchorPoints(l,t,0,b)
    l,t,r,b = obj.cControl:GetAnchorOffsets()
    obj.cControl:SetAnchorOffsets(l,t,defaults.nWidth,b)
  end
  if defaults.nDivide then
    local l,t,r,b = obj.cControl:FindChild("ItemHeader"):GetAnchorPoints()
    obj.cControl:FindChild("ItemHeader"):SetAnchorPoints(l,t,defaults.nDivide,b)
    local l,t,r,b = obj.cControl:FindChild("MainContainer"):GetAnchorPoints()
    obj.cControl:FindChild("MainContainer"):SetAnchorPoints(defaults.nDivide,t,r,b)
  end


  obj.cAddBtn:AddEventHandler("ButtonSignal","event_add",obj)
  obj.cSubtractBtn:AddEventHandler("ButtonSignal","event_subtract",obj)
  obj.cEditBox:AddEventHandler("EditBoxChanged","event_type",obj)
  obj.cHeaderBox:SetText(obj.sHeaderText)
  obj:set_value(obj.nDefaultValue)

  return obj
end

function number_ticker:set_enabled(bEnabled)
  self.cAddBtn:Enable(bEnabled)
  self.cEditBox:Enable(bEnabled)
  self.cSubtractBtn:Enable(bEnabled)
  if bEnabled then
    self.cEditBox:SetTextColor(self.cEnabledColour)
  else
    self.cEditBox:SetTextColor(self.cDisabledColour)
  end
end

function number_ticker:event_add(cHandler, cControl, nMouseBtn)
  self:set_value(self:get_value() + self.nIncrementValue)
end

function number_ticker:event_subtract(cHandler, cControl, nMouseBtn)
  self:set_value(self:get_value() - self.nIncrementValue)
end

function number_ticker:event_type( cHandler, cControl, sText )
  if tonumber(sText) then
    self.nPreviousValue = tonumber(self.cEditBox:GetText())
    self.fOnChangeValue(self, tonumber(sText))
  elseif sText == "" then
    self:set_value(0)
  else
    self:set_value(self.nPreviousValue)
  end
end

function number_ticker:get_value()
  return tonumber(self.cEditBox:GetText()) or self.nDefaultValue
end

function number_ticker:set_value( nValue )
  self.nPreviousValue = nValue
  self.cEditBox:SetText(tostring(nValue or self.nPreviousValue))
  self.fOnChangeValue(self, nValue)
end

setmetatable(number_ticker,{__call=constructor})

Apollo.RegisterPackage(number_ticker,'indigotock.btools.gui.number_ticker',1,{})
