# @cjsx React.DOM


React = require("react/addons")
cx = React.addons.classSet
FormFieldMixin = require("./mixin")

saveBlob = (blob, ref) ->
  blob.url || blob[0].url
  url = blob.url.replace("https://www.filepicker.io", "http://image-cdn.overlap.me")
  ref.set url

Component = React.createClass
    mixins: [FormFieldMixin]
    upload: (e) ->
        e.preventDefault()
        filepicker.pick
            mimetypes: ['image/*']
            container: 'window'
            services: ['COMPUTER', 'FACEBOOK', 'DROPBOX', 'FLICKR', 'INSTAGRAM', 'URL']
        , (blob) =>
            @setState newValue: (blob.url || blob[0].url)
            @save()
        , (type, message) =>
            @setState message: message
    componentDidMount: (e) ->
        element = this.getDOMNode()
        filepicker.makeDropPane element,
            multiple: false
            dragEnter: =>
                @setState hovering: true
            dragLeave: =>
                @setState hovering: false
            onSuccess: (blob) =>
                @setState 
                    newValue: (blob.url || blob[0].url)
                    inProgress: false
                    message: ""
                @save()
            onError: (type, message) =>
                @setState 
                    inProgress: false
                    message: message
            onProgress: (percentage) =>
                @setState 
                    inProgress: true
                    message: percentage
                return
    getInitialState: ->
        hovering: false
        message: ""
        errors: []
        newValue: null

    save: (e) ->
        @setState errors: @validate()
        @props.onUpdate?(@state.errors, @state.newValue)
        return if !@props.fireRef
        return if !@hasChanged()
        ref = new Firebase(@props.fireRef)
        return if @state.errors.length > 0
        ref.set @state.newValue, (error) ->
            console.log "Handle response to save"
        false if e?
    render: ->
        errors = @state.errors
        image = @state.newValue || @state.value
        @transferPropsTo <div className={cx(focus: @state.focus, 'input-group': true, 'input-inline': true)}} onFocus={@handleFocus} onBlur={@handleBlur}>
            <label>Image</label>
            <img style={float:'right', margin:'20px 10px 0 10px'} src={if image then image+"/convert?w=30&h=30&fit=clip" else ""} />
            <a onClick={@upload} className="input-single-action">Choose...</a>
        </div>

module.exports = Component
