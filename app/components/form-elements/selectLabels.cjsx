# @cjsx React.DOM



React = require("react/addons")
cx = React.addons.classSet
FormFieldMixin = require("./mixin-field")

Component = React.createClass
    mixins: [FormFieldMixin]
    getInitialState: ->
        newValue: @props.default
    selectOption: (value) ->
        =>
            @setState newValue: value
            @props.onUpdate?([], value)
            false
    save: (e) ->
        false if e?
    render: ->
        errors = @state.errors || []
        selectOption = @selectOption
        @transferPropsTo <div className={cx('input-group': true, 'input-group-select': true)}} >
            

            {
                @props.options.map (option, index) =>
                    <a href="#" key={option.value} onClick={selectOption(option.value)} className={cx("select-label": true, selected: @state.newValue == option.value, lastChild: index == @props.options.length-1)}>{option.name}</a>
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
