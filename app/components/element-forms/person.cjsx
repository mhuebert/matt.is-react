# @cjsx React.DOM

React = require("react/addons")
cx = React.addons.classSet
Text = require("../form-elements/text")
ImageUpload = require("../form-elements/imageUpload")
DateField = require("../form-elements/date")
FormMixin = require("../form-elements/mixin-form")
v = require("../form-elements/validators")

Component = React.createClass
    mixins: [FormMixin]
    defaults:
      type: "person"

    render: ->
        ref = @ref()
        <div>
          <Text label="Name" 
                validators={[v.required]}
                onUpdate={@update("title")} 
                fireRef={if ref then ref.child("title").toString() else undefined} />

          <ImageUpload  onUpdate={@update("image")}
                        fireRef={if ref then ref.child("image").toString() else undefined} />
          <a href={"/edit/#{element.type}/#{element.id}"} className="edit-content showIfUser"></a>
          
          <Text label="Intro" 
                onUpdate={@update("body")} 
                type="textarea"
                fireRef={if ref then ref.child("body").toString() else undefined} />
          
          <p className={cx(hidden: ref?)}>
            <input onClick={@create} type="submit" className={"btn btn-large btn-white"+(if @state.valid == false then " disabled" else "")} value="Create" />
          </p>
        </div>

module.exports = Component
