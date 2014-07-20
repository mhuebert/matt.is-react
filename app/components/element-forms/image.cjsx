# @cjsx React.DOM

React = require("react/addons")
cx = React.addons.classSet
Text = require("../form-elements/text")
ImageUpload = require("../form-elements/imageUpload")
DateField = require("../form-elements/date")
FormMixin = require("../form-elements/mixin-form")

Component = React.createClass
    mixins: [FormMixin]
    defaults:
      type: "image"
    render: ->
        ref = @ref()
        <div>
          <Text label="text (above)" 
                onUpdate={@update("title")} 
                className="bare"
                fireRef={if ref then ref.child("title").toString() else undefined} />

          <ImageUpload  onUpdate={@update("image")}
                        fireRef={if ref then ref.child("image").toString() else undefined} />
          <Text label="text (below)" 
                onUpdate={@update("body")} 
                type="textarea"
                fireRef={if ref then ref.child("body").toString() else undefined}
                className="bare" />
          <p className={cx(hidden: ref?)}>
            <input onClick={@create} type="submit" className="btn btn-large btn-white" value="Create" />
          </p>
        </div>

module.exports = Component
