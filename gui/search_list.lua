local search_list = {}

function search_list:OnLoad()
  self.xmlDoc = XmlDoc.CreateFromFile('btools/gui/forms.xml')
end

function constructor(self, container, defaults)
  local obj = {}
  setmetatable(obj,{__index = search_list})

  defaults = defaults or {}
  obj.sClass = "search_list"

  obj.xItemDoc = defaults.xItemDoc
  obj.sItemForm = defaults.sItemForm or ""
  obj.aItems = defaults.aItems
  obj.tHandler = defaults.tHandler or obj
  obj.fSearchMatch = defaults.fSearchMatch or function(item,text) return true end
  obj.fBuildItem = defaults.fBuildItem or function(control, item) end
  obj.cControl = Apollo.LoadForm(obj.xmlDoc, obj.BUtilClass, container, obj)
  obj.cSearchBox = obj.cControl:FindChild("SearchBox")
  obj.cItemsList = obj.cControl:FindChild("SearchResultsList")
  obj.bDoneSearching=true

  obj.cSearchBox:AddEventHandler("EditBoxChanged","event_search",obj)
  obj.cSearchBox:AddEventHandler("EditBoxEscape","event_search",obj)

  obj:event_search()

  return obj
end

function search_list:event_search( cHandler, cControl, sText)
  if not self.bDoneSearching then return end
  self.bDoneSearching = false
  sText = sText or ""
  self.cItemsList:DestroyChildren()
  for _, item in pairs(self.aItems) do
    if self.fSearchMatch(item,sText) then
      local control = Apollo.LoadForm(self.xItemDoc, self.sItemForm, self.cItemsList, self.tHandler)
      self.fBuildItem(control,item)
      control:SetData(item)
    end
  end
  self.cItemsList:ArrangeChildrenVert()
  self.bDoneSearching=true
end

setmetatable(search_list,{__call=constructor})

Apollo.RegisterPackage(search_list,'indigotock.btools.gui.search_list',1,{})
