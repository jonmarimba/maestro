'@Namespace MU Utils

function MU_isUndefined(value)
  return type(value) = "<uninitialized>"
end function

function MU_isArray(value)
  return type(value) <> "<uninitialized>" and value <> invalid and GetInterface(value, "ifArray") <> invalid
end function

function MU_isAACompatible(value)
  return type(value) <> "<uninitialized>" and value <> invalid and GetInterface(value, "ifAssociativeArray") <> invalid
end function

function MU_isString(value)
  return type(value) <> "<uninitialized>" and GetInterface(value, "ifString") <> invalid
end function

function MU_isBoolean(value)
  return type(value) <> "<uninitialized>" and GetInterface(value, "ifBoolean") <> invalid
end function

function MU_isFunction(value)
  return type(value) = "Function" or type(value) = "roFunction"
end function

function MU_isInteger(value)
  return type(value) <> "<uninitialized>" and GetInterface(value, "ifInt") <> invalid and (Type(value) = "roInt" or Type(value) = "roInteger" or Type(value) = "Integer")
end function