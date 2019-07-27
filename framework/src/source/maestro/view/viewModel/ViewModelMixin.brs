'@Namespace MVMM VieWModelMixin
'@Import Utils

function MVMM_isVM(vm)
  return MOM_isObservable(vm) and vm.__viewModel = true
end function

function MVMM_createFocusMap(vm) as boolean
  focusMap = {}
  success = false
  if MVMM_isVM(vm)
    if MU_isArray(vm.focusIds)
      for index = 0 to vm.focusIds.count() -1
        key = vm.focusIds[index]
        control = m[key]
        if type(control) = "roSGNode"
          focusMap[key] = control
        else
          logError("createFocusMap : could not find control for id", key)
        end if
      end for
      success = true
    else
      logInfo("no focusMap for vm", vm.name)
    end if
  else
    logError("unknown vm type!")
  end if

  m._focusMap = focusMap
  return success
end function

function MVMM_onFocusIdChange(focusId)
  if focusId <> invalid and focusId <> "" m._focusMap <> invalid
    control = m._focusMap[focusId]
    if control <> invalid
      setFocus(control)
    else
      logError("the focus map contained a focusId that did not exist!", focusId)
    end if
  end if
end function