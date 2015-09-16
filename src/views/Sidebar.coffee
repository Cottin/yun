React = require 'react'
Radium = require 'radium'
{nth, length, map, last, type, curry, has, compose, __, omit, keys, merge, mapObjIndexed, inc} = require 'ramda'
{} = require 'ramda-extras'
{shape, arrayOf, any, func, string, object} = React.PropTypes
PopupView = React.createFactory require './PopupView'
lo = require 'lodash'

{div, input} = React.DOM

defaultOverlayStyle =
	position: 'fixed'
	top: 0
	left: 0
	width: '100%'
	height: '100%'
	zIndex: 999
	overflow: 'hidden'
	backgroundColor: 'rgba(0, 0, 0, 0.3)'

defaultStyle =
	position: 'fixed'
	top: 0
	right: 0
	width: '35%'
	height: '100%'
	overflow: 'auto'


Sidebar = React.createClass
	displayName: 'Sidebar'

	propTypes:
		style: object
		overlayStyle: object

	render: ->
		{style, overlayStyle, children} = @props
		div {style: lo.merge defaultOverlayStyle, overlayStyle},
			div {style: lo.merge defaultStyle, style},
				children
				
module.exports = Sidebar
