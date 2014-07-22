# @cjsx React.DOM

React = require("react/addons")
cx = React.addons.classSet
{FIREBASE_URL, Firebase} = require("../../firebase")

FormMixin = require("../form-elements/mixin-form")
Text = require("../form-elements/text")
DateField = require("../form-elements/date")
ImageUpload = require("../form-elements/imageUpload")
SelectMultipleLabels = require("../form-elements/selectMultipleLabels")
SelectByLabels = require("../form-elements/selectByLabels")
v = require("../form-elements/validators")
_ = require("underscore")

subscriptions = require("../../subscriptions")
{AsyncSubscriptionMixin} = subscriptions

Component = React.createClass
    mixins: [AsyncSubscriptionMixin, FormMixin]
    statics:
        subscriptions: (props) ->
          subs =
            people: subscriptions.List("/people", sort: "a-z")
          # if props.id
          #   subs.element = subscriptions.Object("/elements/#{props.id}")
          subs

    defaults: ->
      type: "text"

    render: ->
        ref = @ref()
        <form >
          <Text label="Title" 
                onUpdate={@update("title")} 
                className="bare"
                autoFocus={true}
                fireRef={if ref then ref.child("title").toString() else undefined}
                inputStyles={
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
          <ImageUpload  onUpdate={@update("image")}
                        fireRef={if ref then ref.child("image").toString() else undefined} />
          <SelectMultipleLabels label="Related People"
                                onUpdate={@update("people")} 
                                options={@subs("people").map((person)->[person.id, person.name])} />
          <p>People</p>
          <p>Topics</p>
          <p>Author</p>
          
          <p className={cx(hidden: ref?)}>
            <input onClick={@create} type="submit" className="btn btn-large btn-white" value="Create" />
          </p>
          <p>
            Things to consider:
            <ul>
              <li>permalinks</li>
              <li>meaningful slugs</li>
              <li>Validations may be asyncronous</li>
              <li>Validations may be required before a form will submit</li>
              <li>A form may display general errors, or field-specific errors</li>
              <li>A form may contain fields which relate to one another</li>
            </ul>
          </p>
        </form>

module.exports = Component
