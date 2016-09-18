React = require 'react'
{object} = React.PropTypes

YunThemeProvider = React.createClass
	propTypes:
		yunTheme: object

	childContextTypes:
		yunTheme: object.isRequired

	getChildContext: ->
		return {yunTheme: @props.yunTheme}

	render: ->
		@props.children

module.exports = YunThemeProvider
