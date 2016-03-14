React = require 'react'
Radium = require 'radium'
EventListener = require 'fbjs/lib/EventListener'
Style = React.createFactory Radium.Style
StyleRoot = React.createFactory Radium.StyleRoot
{div, h1, button, br} = React.DOM
s = require './AppView.style'

LinkDemo = React.createFactory require './LinkDemo'

AppView = Radium React.createClass
	displayName: 'MyComponent'

	getInitialState: ->
		theme: 'kind'

	render: ->
		# if @state.theme == 'kind'
		# 	rules = ThemeKind.GlobalRules
		# else
		# 	rules = ThemeDefault.GlobalRules

		StyleRoot {},
			div {},
				div {style: s.self},
					# Style {rules}
					# h1 {}, 'Yun UI Kit - Demo'
					div {},
						div {}, 'Selected theme: ' + @state.theme
						button {onClick: => @setState(theme:'default')}, 'Default'
						button {onClick: => @setState(theme:'kind')}, 'Kind'
					# MyComponent {comp: React.DOM.input}
					br()
					br()
					# AutoCompleteDemo {theme: @state.theme}
					LinkDemo {}
					br()
					br()
					br()
					br()
					br()
					br()
					br()
					br()
					br()
					br()

module.exports = AppView
