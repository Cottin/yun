React = require 'react'
{div, h2, p, br } = React.DOM
Card = React.createFactory require 'yun-ui-kit/Card'
{} = R = require 'ramda' #auto_require:ramda
{mergeOrEvolve} = require 'ramda-extras'

CardDemo = React.createClass
	displayName: 'CardDemo'

	getInitialState: ->
		isOpen: false

	render: ->
		div {},
			h2 {}, 'Card'
			Card {}, 'This is a simple Card with some text'
			br()
			br()
			Card {looks: ['inline']}, 'This is an inline Card with some text'

module.exports = CardDemo
