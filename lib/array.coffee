validator = require("./validator.js")
type = require("./type.js")
message = require("./message.js")

class type._array extends type.Base
  constructor: (schema) ->
    sc = type(schema)
    sc = type.object(schema)  if not sc and validator.isObject(schema) and type.object
    @schema = sc
    super()

  len: (minOrLen, max, msg) ->
    last = arguments[arguments.length - 1]
    msg = (if typeof last is "number" then null else last)
    @validator ((ar) ->
      validator.len ar, minOrLen, max
    ), (if (typeof max is "number") then message("len_in", msg,
      min: minOrLen
      max: max
    ) else message("len", msg,
      len: minOrLen
    ))
    this

  afterValue: ->
    ob = @_value
    schema = @schema
    len = ob and ob.length
    if schema and len
      i = 0

      while i < len
        ob[i] = schema.val(ob[i]).val()
        i++
    this

  validate: (callback) ->
    self = this
    er1 = undefined
    er2 = @_validate((err) ->
      er1 = self.schema and self._value and self._value.length and self.validateChild(err, callback) or null
    )
    er1 or er2

  validateChild: (err, callback) ->
    iterate = ->
      item = ob[completed]
      schema.val(item).validate (err) ->
        _errors.on completed, err  if err
        next()
    next = ->
      completed++
      if completed is len
        done()
      else
        iterate()
    errors = ->
      _errors.ok and _errors or null
    done = ->
      e = errors()
      callback and callback(e)
      e
    ob = @_value
    completed = 0
    schema = @schema
    _errors = err or new error()
    len = ob.length
    iterate()
    return errors()

  @alias = Array
  @check = (obj) -> validator.isArray obj

  @from = (obj) ->
    if validator.exists(obj)
      if validator.isArray(obj)
        return obj
      else return obj.split(",")  if typeof obj is "string"
    else
      return obj
    null

type.register 'array', type._array

