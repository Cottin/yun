React = require 'react'
Radium = require 'radium'
{nth, length, map, last, type, curry, has, compose, __, omit, keys, merge, mapObjIndexed, inc} = require 'ramda'
{} = require 'ramda-extras'
{shape, arrayOf, any, func, string, object} = React.PropTypes
PopupView = React.createFactory require './PopupView'

{div, input} = React.DOM

style =
	position: 'fixed'
	top: 0
	left: 0
	width: '100%'
	height: '100%'
	zIndex: 999
	overflow: 'auto'
	backgroundColor: '#EDEDE5'

Modal = React.createClass
	displayName: 'Modal'

	render: ->
		div {style}, @props.children

module.exports = Modal
