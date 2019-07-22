'@Namespace BVM BaseViewModel
'@Import rLogMixin
'@Import Utils
'@Import BaseObservable

function BaseViewModel(subClass)
  this = BaseObservable()
  this.append({
    __viewModel: true
    state: "none"
    focusId: invalid
    
    'public
    initialize: MBVM_initialize
    destroy: MBVM_destroy
    onShow: MBVM_onShow
    onHide: MBVM_onHide
    onKeyEvent: MBVM_onKeyEvent
  })
  
  if MU_isAACompatible(subClass) and subClass.name <> invalid and subClass.name <> ""
    this.append(subClass)
    registerlogger(subClass.name, true, this)
  else
    this.state = "invalid"
  end if
  return this
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ public API
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function MBVM_initialize()
  m.logMethod("initialize")
  if MU_isFunction(m._initialize)
    m._initialize()
  end if
  m.state = "initialized"
end function

function MBVM_destroy()
  m.logMethod("destroy")
  if MU_isFunction(m._destroy)
    m._destroy()
  end if
  m.state = "destroyed"
end function

function MBVM_onShow()
  m.logMethod("onShow")
  if MU_isFunction(m._onShow)
    m._onShow()
  end if
end function

function MBVM_onHide()
  m.logMethod("onHide")
  if MU_isFunction(m._onHide)
    m._onHide()
  end if
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ KEY HANDLING
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function MBVM_onKeyEvent(key as string, press as boolean) as boolean
  result = false
  if press
    if MU_isFunction(m._isAnyKeyPressLocked) and m._isAnyKeyPressLocked()
      return true
    end if
    
    if key = "down" and MU_isFunction(m._onKeyPressDown)
      result = _onKeyPressDown()
    else if key = "up" and MU_isFunction(m._onKeyPressUp)
      result = m._onKeyPressUp()
    else if key = "left" and MU_isFunction(m._onKeyPressLeft)
      result = m._onKeyPressLeft()
    else if key = "right" and MU_isFunction(m._onKeyPressRight)
      result = m._onKeyPressRight()
    else if key = "OK" and MU_isFunction(m._onKeyPressOK)
      result = m._onKeyPressOK()
    else if key = "back" and MU_isFunction(m._onKeyPressBack)
      result = m._onKeyPressBack()
    else if key = "options" and MU_isFunction(m._onKeyPressOption)
      result = m._onKeyPressOption()
    else if key = "play" and MU_isFunction(m._onKeyPressPlay)
      result = m._onKeyPressPlay()
    end if
  else
    result = false
  end if
  
  if (result = invalid)
    result = false
  end if
  
  if result = false and MU_isFunction(m._isCapturingAnyKeyPress)
    result = m._isCapturingAnyKeyPress(key, press)
  end if
  
  return result
end function
