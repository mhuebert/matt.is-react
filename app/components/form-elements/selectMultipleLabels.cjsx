# @cjsx React.DOM



React = require("react/addons")
cx = React.addons.classSet
FormFieldMixin = require("./mixin-field")
_ = require("underscore")

Component = React.createClass
    mixins: [FormFieldMixin]
    getInitialState: ->
        newValue: @props.value || @props.default || []
        value: null
    handleChange: (e) ->
        return if e.target.value == "null"
        value = @state.newValue
        value.push e.target.value
        value = _(value).uniq()


        @setState 
            newValue: value
            value: null
        @props.onUpdate?([], value)
        # e.target.value = "null"
        false
    save: (e) ->
        false if e?
    render: ->
        errors = @state.errors || []
        options = [["null", "Add..."]].concat(@props.options)
        availableOptions = _.filter options, (option) => option[0] not in @state.newValue
        getOptionByValue = (value) ->
            for option in options
                console.log "#{option[0]} - #{option[1]}"
                return option[1] if option[0] == value
        @transferPropsTo <div className={cx('input-group': true, 'input-group-select': true)}} >
            
            <select onChange={@handleChange} value="noOp">
                {
                    availableOptions.map (option, index) =>
                        <option key={index} value={option[0]}>{option[1]}</option>
                }    
            </select>
            {
                _(@state.newValue).map (value, index) =>
                    <span href="#" key={value} className={cx("select-label": true)}>{getOptionByValue(value)}</span>
            }
            <div className={"input-message"+(if errors.length > 0 and @state.dirty then " active" else "")}>
            {
                errors.map (error, index) => 
                    <div key={index} className={error.type+" "+(if !@state.dirty then "hidden" else "")}>{error.message}</div>
            }
            </div>
            <label >{@props.label}</label>
            
            <div className="clear" />
        </div>

module.exports = Component
