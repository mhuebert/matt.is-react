# @cjsx React.DOM

_ = require("underscore")
React = require("react/addons")
cx = React.addons.classSet

Body = require("../widgets/body")
NewTypes = require("../widgets/newTypes")
{FIREBASE_URL} = require("../../firebase")

contentForms = require("../element-forms")

SelectByLabels = require("../form-elements/selectByLabels")
# subscriptions = require("../../subscriptions")
# {SubscriptionAsyncMixin} = subscriptions

Component = React.createClass
    componentDidMount: ->
      window.scrollTo(0,0)
    render: ->
        type = @props.matchedRoute.params.type || "text"
        id = @props.matchedRoute.params.id || null
        if id
            breadcrumb = [{url: null, label: 'edit'}, id]
        else
            breadcrumb = ['new']
        Form = contentForms[type]

        formProps = if id then {id: id} else {}

        <Body breadcrumb={breadcrumb} sidebar={true}>
            <NewTypes className={cx({hidden: id?})} />
            {Form(formProps, null)}
            <SelectByLabels label="Status"
                            className="input-inline"
                            default="idea"
                            fireRef={if id then FIREBASE_URL+"/elements/#{id}/status" else undefined}
                            options={[
                                  {name: "Idea", value:"idea"}
                                  {name: "Published", value:"published"}
                              ]}/>
        </Body>

module.exports = Component
