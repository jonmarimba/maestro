'@Only
'@TestSuite [OMT] ObservableMixin Tests

'@BeforeEach
function MOMT_BeforeEach()
  m.defaultBindableProperties = MOM_createBindingProperties()
  m.node.delete("_observerCallbackValue1")
  m.node.delete("_observerCallbackValue2")
  MOM_cleanup()
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests MOM_cleanup
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test
function MOMT_cleanup()
  m.node._observableContextId = 0
  m.node._observables = {}
  m.node._observableFunctionPointers = {}
  m.node._observableFunctionPointerCounts = {}
  m.node._observableNodeBindings = {}
  m.node._observableContext = createObject("roSGNode", "ContentNode")
  m.node._observableContext.addField("bindingMessage", "assocarray", true)
  m.node._observableContext.observeFieldScoped("bindingMessage", "MOM_bindingCallback")
  MOM_cleanup()
  m.assertInvalid(m.node._observableContextId)
  m.assertInvalid(m.node._observables)
  m.assertInvalid(m.node._observableFunctionPointers)
  m.assertInvalid(m.node._observableFunctionPointerCounts)
  m.assertInvalid(m.node._observableNodeBindings)
  m.assertInvalid(m.node._observableContext)
end function
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests checkValidInputs
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test invalid inputs
'@Params[invalid, invalid, invalid, false]
'@Params["", invalid, "", false]
'@Params["  ", invalid, "  ", false]
'@Params["", {}, "", false]
'@Params["valid", {}, "", false]
'@Params["valid", {}, "valid", false]
function MOMT_checkValidInputs(fieldName, targetNode, targetField, expected)
  value = MOM_checkValidInputs(fieldName, targetNode, targetField)

  m.assertEqual(value, expected)
end function

'@Test invalid node ids
'@Params[""]
'@Params["   "]
function MOMT_checkValidInputs_invalid_nodeIds(nodeId)
  targetNode = createObject("roSGNode", "ContentNode")
  targetNode.id = nodeId

  value = MOM_checkValidInputs("fieldName", targetNode, "targetField")

  m.assertFalse(value)
end function

'@Test valid node ids
'@Params["valid1"]
'@Params["valid2"]
function MOMT_checkValidInputs_valid_nodeIds(nodeId)
  targetNode = createObject("roSGNode", "ContentNode")
  targetNode.addField("targetField", "string", false)
  targetNode.id = nodeId

  value = MOM_checkValidInputs("fieldName", targetNode, "targetField")

  m.assertTrue(value)
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests MOM_registerObservable
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test invalid observables
'@Params[invalid]
'@Params[[]]
'@Params["#RBSNode"]
'@Params[{}]
'@Params["invalid"]
'@Params[25]
function MOMT_registerObservable_invalid(observable)
  m.assertFalse(MOM_registerObservable(observable))
end function

'@Test register one
function MOMT_registerObservable_one()
  o1 = BaseObservable()
  o1.id = "o1"
  setContextMock = m.expectOnce(o1, "setContext", ["0", m.ignoreValue])
  m.assertTrue(MOM_registerObservable(o1))
  m.assertEqual(setContextMock.invokedArgs[1], m.node._observableContext)
  m.assertEqual(m.node._observables["0"].id, "o1")
  m.assertEmpty(m.node._observableFunctionPointers)
  m.assertEmpty(m.node._observableNodeBindings)
end function

'@Test register one - multiple times
function MOMT_registerObservable_one_multipleTimes()
  o1 = BaseObservable()
  o1.id = "o1"
  m.assertTrue(MOM_registerObservable(o1))
  m.assertTrue(MOM_registerObservable(o1))
  m.assertTrue(MOM_registerObservable(o1))

  m.assertEqual(o1.contextId, "0")
  m.assertEqual(o1.contextNode, m.node._observableContext)
  m.assertEqual(m.node._observables["0"].id, "o1")
  m.assertEmpty(m.node._observableFunctionPointers)
  m.assertEmpty(m.node._observableNodeBindings)
end function

'@Test register multiple
function MOMT_registerObservable_multiple()
  o1 = BaseObservable()
  o1.id = "o1"
  setContextMock1 = m.expectOnce(o1, "setContext", ["0", m.ignoreValue])
  o2 = BaseObservable()
  o2.id = "o2"
  setContextMock2 = m.expectOnce(o2, "setContext", ["1", m.ignoreValue])
  o3 = BaseObservable()
  o3.id = "o3"
  setContextMock3 = m.expectOnce(o3, "setContext", ["2", m.ignoreValue])
  m.assertTrue(MOM_registerObservable(o1))
  m.assertTrue(MOM_registerObservable(o2))
  m.assertTrue(MOM_registerObservable(o3))
  m.assertEqual(setContextMock1.invokedArgs[1], m.node._observableContext)
  m.assertEqual(setContextMock2.invokedArgs[1], m.node._observableContext)
  m.assertEqual(setContextMock3.invokedArgs[1], m.node._observableContext)
  m.assertEqual(m.node._observables["0"].id, "o1")
  m.assertEqual(m.node._observables["1"].id, "o2")
  m.assertEqual(m.node._observables["2"].id, "o3")
  m.assertEmpty(m.node._observableFunctionPointers)
  m.assertEmpty(m.node._observableNodeBindings)
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests MOM_unregisterObservable
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test invalid observables
'@Params[invalid]
'@Params[[]]
'@Params["#RBSNode"]
'@Params[{}]
'@Params["invalid"]
'@Params[25]
function MOMT_unregisterObservable(observable)
  m.assertFalse(MOM_unregisterObservable(observable))
end function

'@Test multiple
function MOMT_unregisterObservable_multiple()
  o1 = BaseObservable()
  o1.id = "o1"
  o2 = BaseObservable()
  o2.id = "o2"
  o3 = BaseObservable()
  o3.id = "o3"
  m.assertTrue(MOM_registerObservable(o1))
  m.assertTrue(MOM_registerObservable(o2))
  m.assertTrue(MOM_registerObservable(o3))
  m.assertEqual(m.node._observables["0"].id, "o1")
  m.assertEqual(m.node._observables["1"].id, "o2")
  m.assertEqual(m.node._observables["2"].id, "o3")
  m.assertEmpty(m.node._observableFunctionPointers)
  m.assertEmpty(m.node._observableNodeBindings)

  m.expectOnce(o1, "setContext", [invalid, invalid])
  m.expectOnce(o2, "setContext", [invalid, invalid])
  m.expectOnce(o3, "setContext", [invalid, invalid])

  m.assertTrue(MOM_unregisterObservable(o1))
  m.assertInvalid(m.node._observables["0"])
  m.assertEqual(m.node._observables["1"].id, "o2")
  m.assertEqual(m.node._observables["2"].id, "o3")

  m.assertTrue(MOM_unregisterObservable(o2))
  m.assertInvalid(m.node._observables["0"])
  m.assertInvalid(m.node._observables["1"])
  m.assertEqual(m.node._observables["2"].id, "o3")

  m.assertTrue(MOM_unregisterObservable(o3))

  m.assertInvalid(m.node._observableContextId)
  m.assertInvalid(m.node._observables)
  m.assertInvalid(m.node._observableFunctionPointers)
  m.assertInvalid(m.node._observableNodeBindings)
  m.assertInvalid(m.node._observableContext)
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests MOM_isRegistered
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test invalid observables
'@Params[invalid]
'@Params[[]]
'@Params["#RBSNode"]
'@Params[{}]
'@Params["invalid"]
'@Params[25]
function MOMT_isRegistered_invalid(observable)
  m.assertFalse(MOM_isRegistered(observable))
end function

'@Test unregistered observable
function MOMT_isRegistered_unregistered()
  o1 = BaseObservable()
  o1.id = "o1"
  m.assertFalse(MOM_isRegistered(observable))
end function

'@Test registered observable
function MOMT_isRegistered_registered()
  o1 = BaseObservable()
  o1.id = "o1"
  m.assertTrue(MOM_registerObservable(o1))
  m.assertTrue(MOM_isRegistered(o1))
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests MOM_observerCallback
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test not registered
function MOMT_ObserverCallback_notRegistered()
  event = {}
  m.expectNone(event, "getData")

  MOM_observerCallback(event)

  m.assertInvalid(m.node._observerCallbackValue1)
  m.assertInvalid(m.node._observerCallbackValue2)
end function

'@Test observer is registered
function MOMT_ObserverCallback_registered()

  o1 = BaseObservable()
  o1.id = "o1"
  o1.f1 = true
  m.assertTrue(MOM_registerObservable(o1))
  MOM_observeField(o1, "f1", MOMT_callbackTarget1)

  'we need to manually call the MOM_observerCallback - this test is not in a node scope, so
  'the observer callback will not fire
  event = {}
  m.expectOnce(event, "getData", invalid, {"contextId":o1.contextId, "fieldName":"f1"})
  MOM_observerCallback(event)
  m.assertTrue(m.node._observerCallbackValue1)
  m.assertInvalid(m.node._observerCallbackValue2)
end function

'@Test observer with inverse bool result
function MOMT_ObserverCallback_inverseBoolean()
  properties = MOM_createBindingProperties(true, MOM_transform_invertBoolean)
  o1 = BaseObservable()
  o1.id = "o1"
  o1.f1 = true
  m.assertTrue(MOM_registerObservable(o1))
  MOM_observeField(o1, "f1", MOMT_callbackTarget1, properties)

  'we need to manually call the MOM_observerCallback - this test is not in a node scope, so
  'the observer callback will not fire
  event = {}
  m.expect(event, "getData", 2, invalid, {"contextId":o1.contextId, "fieldName":"f1"})
  MOM_observerCallback(event)
  m.assertFalse(m.node._observerCallbackValue1)
  m.assertInvalid(m.node._observerCallbackValue2)

  o1.f1 = false
  MOM_observerCallback(event)
  m.assertTrue(m.node._observerCallbackValue1)
  m.assertInvalid(m.node._observerCallbackValue2)
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests MOM_bindingCallback
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test not registered
function MOMT_BindingCallback_notRegistered()
  event = {}
  m.expectNone(event, "getData")

  m.assertInvalid(m.node._observerCallbackValue1)
  m.assertInvalid(m.node._observerCallbackValue2)
end function

'@Test valid
function MOMT_BindingCallback_valid()
  o1 = BaseObservable()
  o1.id = "o1"
  o1.f1 = false
  n1 = createObject("roSGNode", "ContentNode")
  n1.id = "n1"
  n1.live = true

  m.assertTrue(MOM_registerObservable(o1))
  properties = MOM_createBindingProperties(false)
  MOM_bindNodeField(n1, "live", o1, "f1", properties)

  'we need to manually call the MOM_observerCallback - this test is not in a node scope, so
  'the observer callback will not fire
  event = {}
  m.expectOnce(event, "getNode", invalid, "n1")
  m.expectOnce(event, "getData", invalid, true)
  m.expectOnce(event, "getField", invalid, "live")
  m.assertFalse(o1.f1)
  MOM_bindingCallback(event)
  m.assertTrue(o1.f1)
end function

'@Test inverse transform function
function MOMT_BindingCallback_transformFunction_invert()
  o1 = BaseObservable()
  o1.id = "o1"
  o1.f1 = false
  n1 = createObject("roSGNode", "ContentNode")
  n1.id = "n1"
  n1.live = true

  m.assertTrue(MOM_registerObservable(o1))
  properties = MOM_createBindingProperties(false, MOM_transform_invertBoolean)
  MOM_bindNodeField(n1, "live", o1, "f1", properties)

  'we need to manually call the MOM_observerCallback - this test is not in a node scope, so
  'the observer callback will not fire
  event = {}
  m.expect(event, "getNode", 2, invalid, "n1")
  m.expectOnce(event, "getData", invalid, true)
  m.expect(event, "getField", 2,  invalid, "live")
  m.assertFalse(o1.f1)

  MOM_bindingCallback(event)
  m.assertFalse(o1.f1)

  n1.live = false
  m.expectOnce(event, "getData", invalid, false)
  MOM_bindingCallback(event)
  m.assertTrue(o1.f1)
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests MOM_observeField
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test registered observable
function MOMT_observeField_unregistered()
  o1 = BaseObservable()
  o1.id = "o1"
  m.expectNone(o1, "unobserveField")

  m.assertFalse(MOM_observeField(invalid, "fieldName", MOMT_callbackTarget1))
end function

'@Test invalid observables
'@Params[invalid]
'@Params[[]]
'@Params["#RBSNode"]
'@Params[{}]
'@Params["invalid"]
'@Params[25]
function MOMT_observeField_noFunction(funcValue)
  o1 = BaseObservable()
  o1.id = "o1"
  o1.f1 = true
  m.expectNone(o1, "unobserveField")
  MOM_registerObservable(o1)
  m.assertFalse(MOM_observeField(o1, "f1", funcValue))
end function

'@Test valid observable
function MOMT_observeField_valid()
  o1 = BaseObservable()
  o1.id = "o1"
  m.expectOnce(o1, "observeField", ["fieldName", "momt_callbacktarget1", invalid], true)

  m.assertTrue(MOM_observeField(o1, "fieldName", MOMT_callbackTarget1))

  m.assertEqual(m.node._observableFunctionPointerCounts["momt_callbacktarget1"], 1)
  m.assertEqual(m.node._observableFunctionPointers["momt_callbacktarget1"], MOMT_callbackTarget1)
end function

'@Test multiple function different fields
function MOMT_observeField_valid_sameFunctionMultipleFields()
  o1 = BaseObservable()
  o1.id = "o1"
  m.expectOnce(o1, "observeField", ["f1", "momt_callbacktarget1", invalid], true)
  m.expectOnce(o1, "observeField", ["f2", "momt_callbacktarget1", invalid], true)
  m.expectOnce(o1, "observeField", ["f3", "momt_callbacktarget1", invalid], true)

  m.assertTrue(MOM_observeField(o1, "f1", MOMT_callbackTarget1))
  m.assertTrue(MOM_observeField(o1, "f2", MOMT_callbackTarget1))
  m.assertTrue(MOM_observeField(o1, "f3", MOMT_callbackTarget1))

  m.assertEqual(m.node._observableFunctionPointerCounts["momt_callbacktarget1"], 3)
  m.assertEqual(m.node._observableFunctionPointers["momt_callbacktarget1"], MOMT_callbackTarget1)
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests MOM_unobserveField
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test unregistered observable
function MOMT_unobserveField_unregistered()
  o1 = BaseObservable()
  o1.id = "o1"
  m.expectNone(o1, "unobserveField")

  m.assertFalse(MOM_unobserveField(o1, "fieldName", MOMT_callbackTarget1))
end function

'@Test invalid observables
'@Params[invalid]
'@Params[[]]
'@Params["#RBSNode"]
'@Params[{}]
'@Params["invalid"]
'@Params[25]
function MOMT_unobserveField_noFunction(funcValue)
  o1 = BaseObservable()
  o1.id = "o1"
  o1.f1 = true
  m.expectNone(o1, "unobserveField")
  MOM_registerObservable(o1)
  MOM_unobserveField(o1, "f1", funcValue)
end function

'@Test valid observable
function MOMT_unobserveField_valid()
  o1 = BaseObservable()
  o1.id = "o1"
  m.expectOnce(o1, "unobserveField", ["fieldName", "momt_callbacktarget1"], true)

  m.assertTrue(MOM_observeField(o1, "fieldName", MOMT_callbackTarget1))

  m.assertEqual(m.node._observableFunctionPointerCounts["momt_callbacktarget1"], 1)
  m.assertEqual(m.node._observableFunctionPointers["momt_callbacktarget1"], MOMT_callbackTarget1)

  m.assertTrue(MOM_unobserveField(o1, "fieldName", MOMT_callbackTarget1))

  m.assertInvalid(m.node._observableFunctionPointerCounts["momt_callbacktarget1"])
  m.assertInvalid(m.node._observableFunctionPointers["momt_callbacktarget1"])
end function

'@Test multiple function different fields
function MOMT_unobserveField_valid_sameFunctionMultipleFields()
  o1 = BaseObservable()
  o1.id = "o1"
  m.expectOnce(o1, "unobserveField", ["f1", "momt_callbacktarget1"], true)
  m.expectOnce(o1, "unobserveField", ["f2", "momt_callbacktarget1"], true)
  m.expectOnce(o1, "unobserveField", ["f3", "momt_callbacktarget1"], true)

  m.assertTrue(MOM_observeField(o1, "f1", MOMT_callbackTarget1))
  m.assertTrue(MOM_observeField(o1, "f2", MOMT_callbackTarget1))
  m.assertTrue(MOM_observeField(o1, "f3", MOMT_callbackTarget1))

  m.assertEqual(m.node._observableFunctionPointerCounts["momt_callbacktarget1"], 3)
  m.assertEqual(m.node._observableFunctionPointers["momt_callbacktarget1"], MOMT_callbackTarget1)

  m.assertTrue(MOM_unobserveField(o1, "f1", MOMT_callbackTarget1))
  m.assertEqual(m.node._observableFunctionPointerCounts["momt_callbacktarget1"], 2)
  m.assertEqual(m.node._observableFunctionPointers["momt_callbacktarget1"], MOMT_callbackTarget1)

  m.assertTrue(MOM_unobserveField(o1, "f2", MOMT_callbackTarget1))
  m.assertEqual(m.node._observableFunctionPointerCounts["momt_callbacktarget1"], 1)
  m.assertEqual(m.node._observableFunctionPointers["momt_callbacktarget1"], MOMT_callbackTarget1)

  m.assertTrue(MOM_unobserveField(o1, "f3", MOMT_callbackTarget1))
  m.assertInvalid(m.node._observableFunctionPointerCounts["momt_callbacktarget1"])
  m.assertInvalid(m.node._observableFunctionPointers["momt_callbacktarget1"])
end function

'@Test multiple functions different fields
function MOMT_unobserveField_valid_multiFunctionMultipleFields()
  o1 = BaseObservable()
  o1.id = "o1"
  m.expectOnce(o1, "unobserveField", ["f1", "momt_callbacktarget1"], true)
  m.expectOnce(o1, "unobserveField", ["f2", "momt_callbacktarget1"], true)
  m.expectOnce(o1, "unobserveField", ["f3", "momt_callbacktarget2"], true)

  m.assertTrue(MOM_observeField(o1, "f1", MOMT_callbackTarget1))
  m.assertTrue(MOM_observeField(o1, "f2", MOMT_callbackTarget1))
  m.assertTrue(MOM_observeField(o1, "f3", MOMT_callbackTarget2))

  m.assertEqual(m.node._observableFunctionPointerCounts["momt_callbacktarget1"], 2)
  m.assertEqual(m.node._observableFunctionPointerCounts["momt_callbacktarget2"], 1)
  m.assertEqual(m.node._observableFunctionPointers["momt_callbacktarget1"], MOMT_callbackTarget1)
  m.assertEqual(m.node._observableFunctionPointers["momt_callbacktarget2"], MOMT_callbackTarget2)

  m.assertTrue(MOM_unobserveField(o1, "f1", MOMT_callbackTarget1))
  m.assertEqual(m.node._observableFunctionPointerCounts["momt_callbacktarget1"], 1)
  m.assertEqual(m.node._observableFunctionPointerCounts["momt_callbacktarget2"], 1)
  m.assertEqual(m.node._observableFunctionPointers["momt_callbacktarget1"], MOMT_callbackTarget1)
  m.assertEqual(m.node._observableFunctionPointers["momt_callbacktarget2"], MOMT_callbackTarget2)

  m.assertTrue(MOM_unobserveField(o1, "f2", MOMT_callbackTarget1))
  m.assertInvalid(m.node._observableFunctionPointerCounts["momt_callbacktarget1"])
  m.assertInvalid(m.node._observableFunctionPointers["momt_callbacktarget1"])
  m.assertEqual(m.node._observableFunctionPointerCounts["momt_callbacktarget2"], 1)
  m.assertEqual(m.node._observableFunctionPointers["momt_callbacktarget2"], MOMT_callbackTarget2)

  m.assertTrue(MOM_unobserveField(o1, "f3", MOMT_callbackTarget2))
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests MOM_bindObservableField
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test unregistered observable
function MOMT_bindObservableField_unregistered()
  m.assertFalse(MOM_bindObservableField(invalid, "fieldName", invalid, invalid))
end function

'@Test unregistered observable
function MOMT_bindObservableField_validObservable()
  o1 = BaseObservable()
  o1.id = "o1"
  n1 = createObject("roSGNode", "ContentNode")
  n1.id = "n1"
  m.expectOnce(o1, "bindField", ["fieldName", n1, "targetField", invalid], true)

  m.assertTrue(MOM_bindObservableField(o1, "fieldName", n1, "targetField"))
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests MOM_unbindObservableField
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test unregistered observable
function MOMT_unbindObservableField_unregistered()
  m.assertFalse(MOM_unbindObservableField(invalid, "fieldName", invalid, invalid))
end function

'@Test unregistered observable
function MOMT_unbindObservableField_validObservable()
  o1 = BaseObservable()
  o1.id = "o1"
  n1 = createObject("roSGNode", "ContentNode")
  n1.id = "n1"
  m.expectOnce(o1, "unbindField", ["fieldName", n1, "targetField"], true)

  m.assertTrue(MOM_unbindObservableField(o1, "fieldName", n1, "targetField"))
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ callback functions for observer testing
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function MOMT_callbackTarget1(value)
  m._observerCallbackValue1 = value
end function

function MOMT_callbackTarget2(value)
  m._observerCallbackValue2 = value
end function