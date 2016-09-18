React = require 'react'
{object} = React.PropTypes
{div} = React.DOM
style = require './style/BodyBase.css'

Body = React.createClass

	contextTypes:
    yunTheme: object.isRequired

	renderLayer: ->
		{children} = @props

	render: ->
		theme = @context.yunTheme.Body
		div {className: style.body + " " + theme.body},
			@props.children

module.exports = Body
