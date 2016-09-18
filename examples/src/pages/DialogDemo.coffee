React = require 'react'
Radium = require 'radium'
EventListener = require 'fbjs/lib/EventListener'
{div, h2, p, br, input} = React.DOM
# Dialog = React.createFactory require '../views/Dialog'
# components = require './themes/ComponentsMaterialDesign'
# Dialog = React.createFactory components.Dialog
Dialog = React.createFactory require 'yun-ui-kit/Dialog'
{type} = R = require 'ramda' #auto_require:ramda
{mergeOrEvolve} = require 'ramda-extras'

DialogDemo = React.createClass
	displayName: 'DialogDemo'

	getInitialState: ->
		isOpen: false

	render: ->
		div {},
			h2 {}, 'Dialog'
			p {}, 'Simple dialog'
			br()
			input {type: 'button', value: 'Open dialog', onClick: @toggle}
			Dialog {isOpen: @state.isOpen},
				div {style: {background: '#fff'}}, 'This is some simple content'
				input {type: 'button', value: 'Close', onClick: @close}


	toggle: ->
		@setState {isOpen: !@state.isOpen}

	close: ->
		@setState {isOpen: false}

module.exports = DialogDemo
