React = require 'react'
{div, h2, h4, p, br, span} = React.DOM
Button = React.createFactory require 'yun-ui-kit/Button'
Card = React.createFactory require 'yun-ui-kit/Card'
{type} = R = require 'ramda' #auto_require:ramda
{mergeOrEvolve} = require 'ramda-extras'

ButtonDemo = React.createClass
	displayName: 'ButtonDemo'

	getInitialState: ->
		isOpen: false

	render: ->
		div {},
			h2 {}, 'Button'
			h4 {}, 'Flat buttons'
			Card {},
				div {},
					span {}, 'Normal:'
					Button {looks: ['flat', 'default']}, 'DEFAULT'
					# Button {looks: ['flat', 'primary']}, 'PRIMARY'
					Button {looks: ['flat', 'loud']}, 'LOUD'
					Button {looks: ['flat', 'quiet']}, 'QUIET'
					# Button {kind: 'flat', type: 'default'}, 'DEFAULT'
					# Button {kind: 'flat', type: 'primary'}, 'PRIMARY'
					# Button {kind: 'flat', type: 'secondary'}, 'SECONDARY'
					# Button {kind: 'flat', type: 'quiet'}, 'QUIET'
					# Button {kind: 'flat', disabled: true}, 'DISABLED'
				div {},
					span {}, 'Strong:'
					Button {looks: ['flat', 'default', 'strong']}, 'DEFAULT'
					# Button {looks: ['flat', 'primary']}, 'PRIMARY'
					Button {looks: ['flat', 'loud', 'strong']}, 'LOUD'
					Button {looks: ['flat', 'quiet', 'strong']}, 'QUIET'

				div {},
					span {}, 'Strong and underline:'
					Button {looks: ['flat', 'default', 'strong', 'underline']}, 'DEFAULT'
					# Button {looks: ['flat', 'primary']}, 'PRIMARY'
					Button {looks: ['flat', 'loud', 'strong', 'underline']}, 'LOUD'
					Button {looks: ['flat', 'quiet', 'strong', 'underline']}, 'QUIET'

module.exports = ButtonDemo
