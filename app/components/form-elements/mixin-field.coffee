@validate = (value) ->
    errors = []
    for validation in (@props.validators || [])
        if error = validation(value)
            errors.push error
    errors

@errors = ->
    @state.errors || []

@hasErrors = ->
    @errors().length > 0

@revert = ->
    @setState newValue: undefined
    false
@undo = ->
    @setState 
        undoValue: @state.value
        newValue: @state.undoValue
    false

@hasChanged = ->
    @state.newValue and @state.newValue != @state.value      


@handleFocus = -> 
    @setState focus: true

@componentDidMount = ->
    @props.onUpdate?(@validate(@state.newValue), (@state.newValue||null))