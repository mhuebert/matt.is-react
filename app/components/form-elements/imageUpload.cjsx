# @cjsx React.DOM


React = require("react/addons")
cx = React.addons.classSet
FormFieldMixin = require("./mixin-field")
{Firebase} = require("../../firebase")
{AsyncSubscriptionMixin} = require("../../subscriptions")
firebaseSubscription = require("../../firebaseSubscription")

saveBlob = (blob, ref) ->
  blob.url || blob[0].url
  url = blob.url.replace("https://www.filepicker.io", "http://image-cdn.overlap.me")
  ref.set url

Component = React.createClass
    mixins: [AsyncSubscriptionMixin, FormFieldMixin]
    statics:
        subscriptions: (props) ->
            return {} if !props.fireRef
            value: firebaseSubscription
                ref: new Firebase(props.fireRef)
                parse: (snapshot) -> snapshot.val()
                default: null
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

        # TODO: why do I get an error if I put this in getInitialState?
        @setState 
            hovering: false
            message: ""
            errors: []
            newValue: null
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
    

    save: (e) ->
        @setState errors: @validate(@state.newValue)
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
            <img style={float:'right', margin:'0 0 0 10px'} src={if image then image+"/convert?h=64&fit=clip" else ""} />
            <a href="#" onClick={@upload} className="input-single-action">Choose...</a>
        </div>

module.exports = Component
