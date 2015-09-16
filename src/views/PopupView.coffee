React = require 'react'
Radium = require 'radium'

{bool, object} = React.PropTypes
{div} = React.DOM

defaultStyle =
	position: 'absolute'
	overflowY: 'scroll'
	overflowX: 'hidden'
	maxHeight: 200
	whiteSpace: 'nowrap'

PopupView = React.createClass
	displayName: 'PopupView'

	propTypes:
		style: object

	render: ->
		{style} = @props

		style = merge defaultStyle, style

		div {id:'listan', style}, @props.children

module.exports = Radium PopupView
