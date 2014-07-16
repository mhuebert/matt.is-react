# @cjsx React.DOM

React = require("react/addons")
cx = React.addons.classSet
{FIREBASE_URL} = require("../../firebase")
Form = require("../form/form")
Text = require("../form/text")
DateField = require("../form/date")
SelectByLabels = require("../form/selectLabels")
Computed = require("../form/computed")
v = require("../form/validators")
_ = require("underscore")

Component = React.createClass
    getInitialState: ->
        data:
            type: "text"
        errors: {}
        fireRef: @props.fireRef
    update: (name) ->
        (err, value) =>
            data = @state.data
            data[name] = value
            errors = @state.errors
            errors[name] = err
            @setState 
              data: data  
              errors: errors
    errorCount: ->
      count = 0
      for name, errorObject of @state.errors
        if _(errorObject).keys().length > 0
          count += 1
      count
    create: ->
      if @errorCount() == 0
        ref = new Firebase(FIREBASE_URL)
        ref = ref.child("elements").push()
        id = ref.name()
        obj = @state.data
        obj.owner = user.id
        ref.setWithPriority obj, obj.date
        @setState fireRef: ref

    render: ->
        ref = @state.fireRef
        <Form payload={@state.data} className="barex">
          <Text label="Title" 
                onUpdate={@update("title")} 
                className="bare"
                fireRef={if ref then ref.child("title").toString() else undefined}
                inputStyles={
                  fontWeight: 500
                  fontFamily: "'Helvetica Neue', helvetica, sans-serif"
                  fontSize: 20
                }
                validators={[v.required, v.min(3), v.max(40)]}/>
          <Text label="Body" 
                onUpdate={@update("body")} 
                type="textarea"
                fireRef={if ref then ref.child("body").toString() else undefined}
                className="bare"
                validators={[v.required]}/>
          <DateField  onUpdate={@update("date")}
                      validators={[v.required]}}
                      default={(new Date()).getTime()} 
                      fireRef={if ref then ref.child("date").toString() else undefined}/>
          <SelectByLabels onUpdate={@update("status")} 
                          label="Status"
                          className="input-inline"
                          default="idea"
                          fireRef={if ref then ref.child("status").toString() else undefined}
                          options={[
                                {name: "Idea", value:"idea"}
                                {name: "Published", value:"published"}
                            ]}/>
          
          <p className={cx(hidden: ref?)}>
            <input onClick={@create} type="submit" className="btn btn-large btn-white" value="Create" />
          </p>
          <p>
            Things to consider:
            <ul>
              <li>Validations may be asyncronous</li>
              <li>Validations may be required before a form will submit</li>
              <li>A form may display general errors, or field-specific errors</li>
              <li>A form may contain fields which relate to one another</li>
            </ul>
          </p>
        </Form>

module.exports = Component
