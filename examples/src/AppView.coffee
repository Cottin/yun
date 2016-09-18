React = require 'react'
Radium = require 'radium'
EventListener = require 'fbjs/lib/EventListener'
Style = React.createFactory Radium.Style
StyleRoot = React.createFactory Radium.StyleRoot
{div, h1, button, br} = React.DOM
s = require './AppView.style'
style = require './style.css'
ThemeComfort = require 'yun-ui-kit/themes/Comfort'
ThemeMaterialDesign = require 'yun-ui-kit/themes/MaterialDesign'
ThemeNoTheme = require 'yun-ui-kit/themes/NoTheme'
YunThemeProvider = React.createFactory require 'yun-ui-kit/YunThemeProvider'
Body = React.createFactory require 'yun-ui-kit/Body'

LinkDemo = React.createFactory require './pages/LinkDemo'
ButtonDemo = React.createFactory require './pages/ButtonDemo'
CardDemo = React.createFactory require './pages/CardDemo'
DialogDemo = React.createFactory require './pages/DialogDemo'
PopoverDemo = React.createFactory require './pages/PopoverDemo'
AutoCompleteDemo = React.createFactory require './pages/AutoCompleteDemo'

AppView = Radium React.createClass
	displayName: 'AppView'

	getInitialState: ->
		theme: 'MaterialDesign'

	render: ->
		# if @state.theme == 'kind'
		# 	rules = ThemeKind.GlobalRules
		# else
		# 	rules = ThemeDefault.GlobalRules

		yunTheme = switch @state.theme
			when 'Comfort' then ThemeComfort
			when 'MaterialDesign' then ThemeMaterialDesign
			when 'NoTheme' then ThemeNoTheme

		console.log 'yunTheme', yunTheme

		# StyleRoot {},
		YunThemeProvider {yunTheme},
			Body {},
				div {},
					div {style: s.self},
						# Style {rules}
						# h1 {}, 'Yun UI Kit - Demo'
						div {},
							div {}, 'Selected theme: ' + @state.theme
							button {onClick: => @setState(theme:'MaterialDesign')}, 'MaterialDesign'
							button {onClick: => @setState(theme:'Comfort')}, 'Comfort'
							button {onClick: => @setState(theme:'NoTheme')}, 'NoTheme'
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
						ButtonDemo {}
						br()
						br()
						br()
						br()
						br()
						CardDemo {}
						br()
						br()
						br()
						br()
						br()
						DialogDemo {}
						br()
						br()
						br()
						br()
						br()
						PopoverDemo {}
						br()
						br()
						br()
						br()
						br()
						AutoCompleteDemo {}
						br()
						br()
						br()
						br()
						br()

module.exports = AppView
