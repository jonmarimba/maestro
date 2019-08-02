'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ Initialization
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function init()
  registerLogger("TabChildScreen")
  logMethod("init")
  m.top.navController = m.top.findNode("navController")
  initializeView(m.top.navController)
  m.isFirstScreenCreated = false
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ Private impl
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function createFirstScreen()
  logMethod("createFirstScreen")
  if m.top.content <> invalid
    if m.top.content <> invalid
      push(m.top.content)
      m.isFirstScreenCreated = true
    else
      logError("no screen ")
    end if
  else
    logError("content was invalid!")
  end if
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ Key handling
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function _onKeyPressBack() as boolean
  logMethod("_onKeyPressBack")
  if m.top.navController.numberOfViews > 1
    pop()
    setFocus(m.top.navController)
    return true
  end if
  return false
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ Lifecycle methods
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function _onShow()
  logMethod("_onShow")
  if m.isFirstScreenCreated
    reset()
  else
    createFirstScreen()
  end if
  m.top.navController.visible = true
end function

function _onHide()
  logMethod("_onHide")
  m.top.navController.visible = false
  reset()
end function

function _onGainedFocus(isSelfFocused)
  logMethod("_onGainedFocus ", isSelfFocused)
  if isSelfFocused
    setFocus(m.top.navController)
  end if
end function
