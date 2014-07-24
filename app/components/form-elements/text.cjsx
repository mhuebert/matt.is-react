# @cjsx React.DOM

React = require("react")
cx = React.addons.classSet
{Firebase} = require("../../firebase")
{AsyncSubscriptionMixin} = require("../../subscriptions")
firebaseSubscription = require("../../firebaseSubscription")
_ = require("underscore")
FormFieldMixin = require("./mixin-field")

borderHeight = (element) ->
    styles = getComputedStyle(element)
    height = parseInt(styles.getPropertyValue('border-top-width')) + parseInt(styles.getPropertyValue('border-bottom-width'))
    height

Component = React.createClass
    mixins: [AsyncSubscriptionMixin, FormFieldMixin]
    statics:
        subscriptions: (props) ->
            return {} if !props.fireRef
            value: firebaseSubscription
                ref: new Firebase(props.fireRef)
                parse: (snapshot) -> snapshot.val()
                default: null
                shouldUpdateSubscription: (oldProps, newProps) ->
                    oldProps.fireRef != newProps.fireRef
    getInitialState: -> {}
    getDefaultProps: -> type: "input"
    handleBlur: -> 
        @save()
        @setState 
            focus: false
            dirty: true
    handleChange: (e) ->
        value = e.target.value
        errors = @validate(e.target.value)
        @setState 
            newValue: value
            errors: errors
        @props.onUpdate?(errors, value)
    handleKeyDown: (e) ->
        saveCodes = [9]
        if saveHotkey = (e.metaKey == true and e.which == 83)
            e.preventDefault()
        if @props.type == "input"
            saveCodes.push 13
            e.preventDefault() if e.which == 13
        if e.which in saveCodes or saveHotkey == true
            @save()
    save: (e) ->
        return if !@hasChanged()
        @setState errors: @validate(@state.newValue)
        return if !@props.fireRef
        ref = new Firebase(@props.fireRef)
        @setState 
            undoValue: @state.value
        return if @state.errors.length > 0
        ref.set @state.newValue, (error) ->
            console.log "Handle response to save"
        false if e?

    autoSize: ->
        return if @props.type != "textarea"
        textarea = this.refs.textElement.getDOMNode()
        height = parseInt(textarea.scrollHeight) + borderHeight(textarea)
        textarea.style.height = height + "px"
    handleKeyUp: (e) ->
        return if @props.type != "textarea"
        if e.which == 8
            @clearAutoSize() 
    clearAutoSize: ->
        return if @props.type != "textarea"
        doc = document.documentElement;
        left = (window.pageXOffset || doc.scrollLeft) - (doc.clientLeft || 0)
        top = (window.pageYOffset || doc.scrollTop)  - (doc.clientTop || 0)
        textarea = this.refs.textElement.getDOMNode()
        textarea.style.height = "auto"
        textarea.style.height = textarea.scrollHeight + "px"
        window.scrollTo left, top

    componentDidMount: ->
        @autoSize()
        @autoFocus()
    autoFocus: ->
        if @props.autoFocus == true
            this.refs.textElement.getDOMNode().focus()
    componentDidUpdate: ->
        @autoSize()
    componentWillReceiveProps: (nextProps) ->
        if @props.fireRef and !nextProps.fireRef
            @replaceState {}
            @autoFocus()
        setTimeout =>
            @clearAutoSize()
        , 100
    render: ->
        hasUndo = @state.undoValue?
        type = if @props.type == "textarea" then "textarea" else "input"
        errors = @errors() || []

        textElementProps = 
            className: cx(error: (errors.length > 0 and @state.dirty))
            onChange: @handleChange
            onKeyDown: @handleKeyDown
            onKeyUp: @handleKeyUp
            value: (if @state.newValue == undefined then @state.value else @state.newValue) || ""
            name: if type == "input" then @props.name else ""
            ref: "textElement"
            placeholder: @props.placeholder || "Type here..."
            style: @props.inputStyles||{}

        textElement = switch type
            when "textarea"
                React.DOM.textarea
            when "input"
                React.DOM.input


        @transferPropsTo <div className={cx(focus: @state.focus, 'input-group': true)}} onFocus={@handleFocus} onBlur={@handleBlur}>
            {textElement(textElementProps, null)}
            <label for={@props.name}>{@props.label}</label>
            <div className={"input-message"+(if errors.length > 0 and @state.dirty then " active" else "")}>
            {
                errors.map (error, index) => 
                    <div key={index} className={error.type+" "+(if !@state.dirty then "hidden" else "")}>{error.message}</div>
            }
            </div>
            <div className={cx(actions:true, hidden:(!@props.fireRef))}>
              <a tabIndex="-1" className={cx(hidden: !hasUndo)} onClick={@undo}  href="#">Undo</a>
              <a tabIndex="-1" className={cx(hidden: !@hasChanged())} onClick={@revert}  href="#">Revert</a>
              <a tabIndex="-1" className={cx(hidden: (!@hasChanged() or @hasErrors()))} onClick={@save} href="#">Save</a>
            </div>
        </div>

module.exports = Component
