# @cjsx React.DOM

# daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

# A year is a leap year IF: 1) It's divisible by 4 and 2) It's not divisible by 100 unless 3) it's divisible by 400. 2000 was a leap year, 2100 won't be. You should probably get it working for simple division by 4 first, then add the extra rules.

# ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][(new Date()).getDay()]

# new Date().getDay();  //0=Sun, 1=Mon, ..., 6=Sat

# new Date(year, month, day, hour, minute, second, millisecond)

# Today
# Tomorrow
# Yesterday

weekday = []
weekday[0]=  "Sunday"
weekday[1] = "Monday"
weekday[2] = "Tuesday"
weekday[3] = "Wednesday"
weekday[4] = "Thursday"
weekday[5] = "Friday"
weekday[6] = "Saturday"

month = []
month[0] = "January"
month[1] = "February"
month[2] = "March"
month[3] = "April"
month[4] = "May"
month[5] = "June"
month[6] = "July"
month[7] = "August"
month[8] = "September"
month[9] = "October"
month[10] = "November"
month[11] = "December"



React = require("react/addons")
cx = React.addons.classSet
FormFieldMixin = require("./mixin")

Component = React.createClass
    mixins: [FormFieldMixin]
    getInitialState: -> 
        today = new Date()
        year: today.getFullYear()
        month: today.getMonth()
        day: today.getDate()
        newValue: @props.default
        errors: []
    dateInWords: (date) ->
        weekday[date.getDay()]+", "+month[date.getMonth()]+" "+date.getDate()+", "+date.getFullYear()
    handleBlur: -> 
        @save()
        @setState 
            focus: false
    handleChange: ->
        state = 
            year: @refs.year.getDOMNode().value
            month: @refs.month.getDOMNode().value
            day: @refs.day.getDOMNode().value
        state.newValue = (new Date(state.year, state.month, state.day)).getTime()
        # state.dateInWords = @dateInWords new Date(state.year, state.month, state.day)
        @props.onUpdate?([], state.newValue)
        @setState state


    save: (e) ->
        @setState errors: @validate()
        return if !@props.fireRef
        return if !@hasChanged()
        ref = new Firebase(@props.fireRef)
        @setState 
            undoValue: @state.value
        return if @state.errors.length > 0
        ref.set @state.newValue, (error) ->
            console.log "Handle response to save"
        false if e?
    render: ->
        errors = @state.errors || []
        @transferPropsTo <div className={cx(focus: @state.focus, 'input-group': true, 'input-inline': true)}} onFocus={@handleFocus} onBlur={@handleBlur}>
            
            <div className="input-subgroup">
                <label htmlFor="month">Month</label>
                <select ref="month" onChange={@handleChange} value={@state.month}>
                {
                    month.map (month, index) =>
                        <option value={index} key={index}>{month}</option>
                }
                </select>

            </div>
            <div className="input-subgroup">
                <input onChange={@handleChange} ref="day" style={width:45} name="day" value={@state.day} />
                <label htmlFor="day">Day</label>
            </div>
            <div className="input-subgroup">
                <input onChange={@handleChange} ref="year" style={width:60} name="year" value={@state.year}/>
            </div>
            
            <div className={"input-message"+(if errors.length > 0 and @state.dirty then " active" else "")}>
            {
                errors.map (error, index) => 
                    <div key={index} className={error.type+" "+(if !@state.dirty then "hidden" else "")}>{error.message}</div>
            }
            </div>
            <div className={cx(actions:true, hidden:(!@props.fireRef))}>
              <a tabIndex="-1" className={cx(hidden: !@hasChanged())} onClick={@save} href="#">Save</a>
            </div>
            <div className="clear" />
        </div>

module.exports = Component
