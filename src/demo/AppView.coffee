React = require 'react'
AutoCompleteDemo = React.createFactory require './AutoCompleteDemo'
{div, h1, p, br, ul, li, span, strong, em, pre, button} = React.DOM
Radium = require('radium');
ThemeDefault = require '../themes/default/ThemeDefault'
ThemeKind = require '../themes/kind/ThemeKind'
Style = React.createFactory Radium.Style
utils = require '../utils/utils'
{min, values} = require 'ramda' #auto_require:ramda

MyComponent = React.createFactory React.createClass
	displayName: 'MyComponent'
	propTypes:
		comp: React.PropTypes.element

	render: ->
		div {},
			this.props.comp {id: 'dummy1'}

AppView = React.createClass
	displayName: 'AppView'

	getInitialState: ->
		theme: 'kind'

	render: ->
		rules = if @state.theme == 'kind' then ThemeKind.GlobalRules else ThemeDefault.GlobalRules

		mainStyle =
			width: 600
			margin: '0 auto'

		liStyle =
			marginBottom: 15

		preStyle =
			backgroundColor:'#fff'
			border: '1px solid #464646'
			padding: 10
			fontFamily: 'monospace'
			whiteSpace: 'pre'

		# window.matchMedia('(min-width: 400px)').addListener (x) ->
		# 	if x.matches then console.log '400px or more'
		# 	else console.log 'less than 400px'
		
		# sizes = values utils.screenSizes
		# console.log 'size starts at', utils.closestWindowWidth(sizes)

		div {style:mainStyle},
			Style {rules}
			h1 {}, 'Yun UI Kit - Demo'
			div {},
				div {}, 'Selected theme: ' + @state.theme
				button {onClick: => @setState(theme:'default')}, 'Default'
				button {onClick: => @setState(theme:'kind')}, 'Kind'
			# MyComponent {comp: React.DOM.input}
			br()
			br()
			AutoCompleteDemo {theme: @state.theme}
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

module.exports = Radium AppView
