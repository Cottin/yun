React = require 'react'
{bool, object} = React.PropTypes
{} = require 'ramda' #auto_require:ramda
{div} = React.DOM
style = require './style/ButtonBase.css'
{prepareLooks} = require './utils/componentUtils'

Button = React.createClass

	contextTypes:
		yunTheme: object.isRequired

	render: ->
		theme = @context.yunTheme.Button
		{looks} = @props
		looks_ = prepareLooks looks, style, theme
		div
			className: style.button + " " + theme.button + ' ' + looks_
		,
			@props.children

module.exports = Button
