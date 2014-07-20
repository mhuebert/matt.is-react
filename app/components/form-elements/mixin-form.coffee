{FIREBASE_URL, Firebase} = require("../../firebase")

@getInitialState = -> {}

@update = (name) ->
    (err, value) =>
        data = @state.data || {}
        data[name] = value
        errors = @state.errors || {}
        errors[name] = err
        @setState 
          data: data  
          errors: errors
@errorCount = ->
  count = 0
  for name, errorObject of @state.errors
    if _(errorObject).keys().length > 0
      count += 1
  count

@create = ->
  if @errorCount() == 0
    ref = new Firebase(FIREBASE_URL)
    ref = ref.child("elements").push()
    id = ref.name()
    obj = date: (new Date()).getTime()
    if defaults = @defaults?() || @defaults
      _.extend obj, defaults
    _.extend obj, @state.data
    obj.owner = user.id

    ref.setWithPriority obj, obj.date

@ref = -> if @props.id then (new Firebase(FIREBASE_URL+"/elements/#{@props.id}")) else null