React = require 'react'
{bool, object} = React.PropTypes
{} = require 'ramda' #auto_require:ramda
{div} = React.DOM
Portal = React.createFactory require './helpers/Portal'
style = require './style/DialogBase.css'

Dialog = React.createClass
	propTypes:
		isOpen: bool

	contextTypes:
    yunTheme: object.isRequired

	renderLayer: ->
		{children} = @props
		theme = @context.yunTheme.Dialog

		div {className: style.layer + " " + theme.layer},
			children

	render: ->
		{isOpen} = @props
		if !isOpen then return null
		Portal {renderFn: @renderLayer}

module.exports = Dialog
