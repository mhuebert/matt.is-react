@required = (value) ->
  if !value or value == ""
    type: "error"
    message: "Required"

@min = (min) ->
  (value) ->
    if value?.length < min
      type: "error"
      message: "Too short"

@max = (max) ->
  (value) ->
    if value?.length > max
      type: "error"
      message: "Too long"
