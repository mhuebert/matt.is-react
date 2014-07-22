# @cjsx React.DOM



React = require("react/addons")
cx = React.addons.classSet
FormFieldMixin = require("./mixin-field")
{AsyncSubscriptionMixin} = require("../../subscriptions")
firebaseSubscription = require("../../firebaseSubscription")
{Firebase} = require("../../firebase")

Component = React.createClass
    mixins: [AsyncSubscriptionMixin, FormFieldMixin]
    statics:
        subscriptions: (props) ->
            return {} if !props.fireRef
            value: firebaseSubscription
                ref: new Firebase(props.fireRef)
                parse: (snapshot) -> snapshot.val()
                default: null
    # componentDidMount: ->
    #     @setState
    #         newValue: @props.default
    #         errors: []
    
    selectOption: (value) ->
        =>
            @setState newValue: value
            if @onUpdate?
                @props.onUpdate([], value)
            else
                @save(value)
            false
    save: (value) ->
        @setState errors: @validate(value)
        if !@props.fireRef or @errors().length > 0
            return
        ref = new Firebase(@props.fireRef)
        ref.set value, (error) ->
            console.log "Handle response to save"

    render: ->
        errors = @state.errors || []
        selectOption = @selectOption
        currentValue = if @state.newValue == undefined then @state.value else @state.newValue
        @transferPropsTo <div className={cx('input-group': true, 'input-group-select': true)}} >

            {
                @props.options.map (option, index) =>
                    <a href="#" key={option.value} onClick={selectOption(option.value)} className={cx("select-label": true, selected: option.value == currentValue, lastChild: index == @props.options.length-1)}>{option.name}</a>
            }
            <label >{@props.label}</label>
            <div className={"input-message"+(if errors.length > 0 and @state.dirty then " active" else "")}>
            {
                errors.map (error, index) => 
                    <div key={index} className={error.type+" "+(if !@state.dirty then "hidden" else "")}>{error.message}</div>
            }
            </div>
            <div className="clear" />
        </div>

module.exports = Component
