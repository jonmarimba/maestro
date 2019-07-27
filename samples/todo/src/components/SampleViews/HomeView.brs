function Init()
  registerLogger("HomeView")
  findNodes(["titleLabel", "itemList", "addButton", "removeButton"])
  findNodes(["noItemLabel"])
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ Lifecycle methods
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function _initialize(args)
  m.vm = TodoScreenVM()
  m.vm.initialize()
  MVMM_createFocusMap(m.vm)
  noInitialValueProps = MOM_createBindingProperties(false)
  MOM_bindObservableField(m.vm, "items", m.itemList, "content")
  MOM_bindObservableField(m.vm, "hasItems", m.itemList, "visible")
  MOM_bindObservableField(m.vm, "focusedIndex", m.itemList, "jumpToItem")
  MOM_bindObservableField(m.vm, "hasItems", m.noItemLabel, "visible", MOM_createBindingProperties(true, MOM_transform_invertBoolean))
  MOM_bindObservableField(m.vm, "focusedItem", m.titleLabel, "text", MOM_createBindingProperties(true, getFocusTitle))
  MOM_bindNodeField(m.itemList, "itemFocused", m.vm, "focusItemAtIndex", noInitialValueProps)
  MOM_bindNodeField(m.addButton, "buttonSelected", m.vm, "addTodo", noInitialValueProps)
  MOM_bindNodeField(m.removeButton, "buttonSelected", m.vm, "removeTodo", noInitialValueProps)
  MOM_observeField(m.vm, "focusId", MVMM_onFocusIdChange)
end function

function getFocusTitle(value)
  if value <> invalid
    return "yiisssity yiss " + value.title
  else
    return "nopppity nope"
  end if
end function