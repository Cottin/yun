React = require 'react'
{bool, object, arrayOf, string} = React.PropTypes
{merge} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'
{div} = React.DOM
style = require './style/CardBase.css'
{prepareLooks} = require './utils/componentUtils'

Card = React.createClass
	
	propTypes:
		isInline: bool
		looks: arrayOf(string)

	contextTypes:
		yunTheme: object.isRequired

	render: ->
		theme = @context.yunTheme.Card
		{looks} = @props
		# style_ = if isInline then {display: 'inline-flex'} else {}
		looks_ = prepareLooks looks, style, theme
		div
			className: style.card + ' ' + theme.card + ' ' + looks_
			# style: merge style_, @props.style || {}
		,
			@props.children

module.exports = Card
