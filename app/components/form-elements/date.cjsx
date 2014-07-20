# @cjsx React.DOM

daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

# A year is a leap year IF: 1) It's divisible by 4 and 2) 
# It's not divisible by 100 unless 3) it's divisible by 400. 2000 was a leap year, 2100 won't be. 
# You should probably get it working for simple division by 4 first, then add the extra rules.




# ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][(new Date()).getDay()]

# new Date().getDay();  //0=Sun, 1=Mon, ..., 6=Sat

# new Date(year, month, day, hour, minute, second, millisecond)

# Today
# Tomorrow
# Yesterday



days = []
days[0]=  "Sunday"
days[1] = "Monday"
days[2] = "Tuesday"
days[3] = "Wednesday"
days[4] = "Thursday"
days[5] = "Friday"
days[6] = "Saturday"

months = []
months[0] = "January"
months[1] = "February"
months[2] = "March"
months[3] = "April"
months[4] = "May"
months[5] = "June"
months[6] = "July"
months[7] = "August"
months[8] = "September"
months[9] = "October"
months[10] = "November"
months[11] = "December"



React = require("react/addons")
cx = React.addons.classSet
FieldMixin = require("./mixin-field")

Component = React.createClass
    mixins: [FieldMixin]
    getInitialState: -> 
        today = new Date()
        year: today.getFullYear()
        month: today.getMonth()
        day: today.getDate()
        hours: today.getHours()
        newValue: @props.default
        errors: []
    dateInWords: (date) ->
        days[date.getDay()]+", "+months[date.getMonth()]+" "+date.getDate()+", "+date.getFullYear()
    handleBlur: -> 
        @save()
        @setState 
            focus: false
    handleChange: ->
        state = 
            year: @refs.year.getDOMNode().value
            month: @refs.month.getDOMNode().value
            day: @refs.day.getDOMNode().value
            hours: @refs.hours.getDOMNode().value
            minutes: @refs.minutes.getDOMNode().value
        state.newValue = (new Date(state.year, state.month, state.day, state.hours)).getTime()
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
        monthLength = daysInMonth[@state.month]
        currentYear = (new Date()).getFullYear()
        if parseInt(@state.month) == 1
            year = parseInt @state.year
            if year % 2 == 0 and year % 4 == 0
                if year % 100 != 0 or (year % 100 == 0 and year % 400 == 0)
                    monthLength = 29

        @transferPropsTo <div className={cx(focus: @state.focus, 'input-group': true, 'input-inline': true, 'input-group-select': true)}} onFocus={@handleFocus} onBlur={@handleBlur}>
            
            <select ref="month" onChange={@handleChange} value={@state.month}>
            {
                months.map (month, index) =>
                    <option value={index} key={index}>{month}</option>
            }
            </select>

            <select ref="day" onChange={@handleChange} value={@state.day}>
            {
                [0..monthLength-1].map (index) =>
                    <option value={index} key={index}>{index+1}</option>
            }
            </select>
            <select ref="year" onChange={@handleChange} value={@state.year}>
            {
                [currentYear-10...currentYear+2].map (index) =>
                    <option value={index} key={index}>{index}</option>
            }
            </select>
        
            <select ref="hours" onChange={@handleChange} value={@state.hours}>
            {
                [0..23].map (index) =>
                    if index < 12
                        hour = "#{index} am"
                    else
                        hour = "#{index-12} pm"
                    if index == 0
                        hour = "12 am"
                    <option value={index} key={index}>{hour}</option>
            }
            </select>
            <label>Date</label>
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
