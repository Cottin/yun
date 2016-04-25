React = require 'react'
{bool} = React.PropTypes
{} = require 'ramda' #auto_require:ramda
{div} = React.DOM
Portal = React.createFactory require './Portal'

style =
	position: 'fixed'
	zIndex: 99999
	top: 0
	left: 0
	display: 'flex'
	justifyContent: 'center'
	alignItems: 'center'
	width: '100%'
	height: '100%'
	background: 'rgba(0, 0, 0, 0.32)'

Dialog = React.createClass
	propTypes:
		isOpen: bool

	renderLayer: ->
		div {style},
			@props.children

	render: ->
		{isOpen} = @props
		if !isOpen then return null
		# div {}, 'vad är detta?'
		Portal {renderFn: @renderLayer}

module.exports = Dialog
