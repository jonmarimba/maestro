'@Only
'@TestSuite [MBVMT] BaseViewModel Tests

'@BeforeEach
function MBVMT_BeforeEach()
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests simple constructor
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test invalid
'@Params[invalid]
'@Params[{}]
'@Params["wrong"]
'@Params[[]]
'@Params[{"prop":invalid}]
'@Params[{"name":""}]
function MBVMT_constructor_invalid(subClass)
  vm = BaseViewModel(subClass)
  m.assertEqual(vm.state, "invalid")
end function

'@Test valid
function MBVMT_constructor_valid()
  subClass = {
    name: "testVM"
  }
  vm = BaseViewModel(subClass)
  m.assertEqual(vm.state, "none")
  m.assertEqual(vm.name, "testVM")
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests vm class functions correctly, with scoped methods
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test valid
function MBVMT_testVM()
  vm = MBVMT_createVM()
  m.assertEqual(vm.state, "none")
  m.assertEqual(vm.name, "testVM")

  vm.initialize()
  m.assertEqual(vm.state, "initialized")

  vm.setAge(23)
  m.assertEqual(vm.getAge(), 23)
end function

'@Test calls abstract methods
function MBVMT_testVM_abstractMethods()
  vm = MBVMT_createVM()
  m.assertEqual(vm.state, "none")
  m.assertEqual(vm.name, "testVM")

  vm.initialize()
  m.assertEqual(vm.state, "initialized")
  m.assertTrue(vm.isInitCalled)

  vm.onShow()
  m.assertTrue(vm.isOnShowCalled)

  vm.onHide()
  m.assertTrue(vm.isOnHideCalled)

  vm.destroy()
  m.assertTrue(vm.isDestroyCalled)
end function

'@Test timeConstructor
function MBVMT_timeConstructor()
  vm = MBVMT_createVM()
end function

'@Test time method calls
function MBVMT_testVM_time()
  vm = MBVMT_createVM()
  vm.initialize()
  vm.onShow()
  vm.onHide()
  vm.destroy()
end function

function MBVMT_getAge()
  return m.age
end function

function MBVMT_setAge(age)
  return m.setField("age", age)
end function

function MBVMT_customInitialize()
  m.isInitCalled = true
end function

function MBVMT_customOnShow()
  m.isOnShowCalled = true
end function

function MBVMT_customOnHide()
  m.isOnHideCalled = true
end function

function MBVMT_customDestroy()
  m.isDestroyCalled = true
end function

function MBVMT_createVM()
  subClass = {
    name: "testVM"
    getAge: MBVMT_getAge
    setAge: MBVMT_setAge
    _initialize: MBVMT_customInitialize
    _destroy: MBVMT_customDestroy
    _onShow: MBVMT_customOnShow
    _onHide: MBVMT_customOnHide
  }
  return BaseViewModel(subClass)
end function
