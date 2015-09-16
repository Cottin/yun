React = require 'react'
Radium = require 'radium'

{AutoComplete} = require '../themes/default/ThemeDefault'
AutoComplete = React.createFactory AutoComplete

{AutoComplete: AutoCompleteKind} = require '../themes/kind/ThemeKind'
AutoCompleteKind = React.createFactory AutoCompleteKind

data = require './data'
{div, span, p, br, h3, h2, input} = React.DOM
City = require './City'

{cc} = require 'ramda-extras'

ThereIsMoreMessage = React.createFactory React.createClass
	displayName: 'ThereIsMoreMessage'

	render: -> div {style: {padding: 4}}, 'Showing top 50...'

AutoCompleteDemo = React.createClass
	displayName: 'AutoCompleteDemo'

	propTypes:
		theme: React.PropTypes.string

	getInitialState: ->
		autoCompleteText: ''
		selectedCity: null

	render: ->
		style =
			':hover':
				backgroundColor: 'blue'
		div {},
			h2 {}, 'AutoComplete'
			p {}, 'Dependent of your window size, this component is rendered as a "popup", "sidebar" or "modal", so try resizing your browser window.'
			p {}, 'The 600 biggest cities by 2011'
			br()
			@_renderAutoComplete()

	_renderAutoComplete: ->
		{selectedCity, autoCompleteText} = @state
		containsText = compose test, RegExp, toLower

		autoCompleteComponent = if @props.theme == 'kind' then AutoCompleteKind else AutoComplete
		autoCompleteComponent
			items: data.cities
			selectedItem: selectedCity
			filterFn: (item) -> cc containsText(autoCompleteText), toLower, prop('name'), item
			onPicked: ({item}) =>
				@setState
					selectedCity: item
					autoCompleteText: propOr '', 'name', item
			input:
				component: React.DOM.input
				props:
					value: propOr autoCompleteText, 'name', selectedCity
					placeholder: 'Enter a city'
					onChange: (e) => @setState {autoCompleteText: e.target.value, selectedCity: null}
			popup:
				itemComponent: City
				props: {autoCompleteText}
			modal:
				itemComponent: City
				props: {autoCompleteText}
			sidebar:
				itemComponent: City
				props: {autoCompleteText}
			optimize:
				renderOnlyTop: 50
				thereIsMoreComponent: ThereIsMoreMessage


	# when this is fixed https://github.com/gaearon/react-hot-loader/issues/145
	# ...you could do something like this instead
	# _renderInput: ({ref, onFocus, onBlur, onKeyDown, onChange, style}) ->
	# 	{autoCompleteText, selectedCity} = @state
	# 	React.DOM.input
	# 		ref: ref
	# 		value: if selectedCity then selectedCity.name else autoCompleteText
	# 		style: style
	# 		placeholder: 'Enter a city'
	# 		onChange: utils.callAll onChange, (e) => @setState {autoCompleteText: e.target.value, selectedCity: null}
	# 		onFocus: onFocus
	# 		onBlur: onBlur
	# 		onKeyDown: onKeyDown

	# _renderCity: ({item, isSelected}) ->
	# 	{autoCompleteText} = @state
	# 	style =
	# 		backgroundColor: if isSelected then '#f5f5f5'
	# 		padding: '4px'

	# 	if ! test RegExp(autoCompleteText), item.name
	# 		div {style, key:item.name},
	# 			span {}, item.name + 'hej5'
	# 	else
	# 		index = indexOf toLower(autoCompleteText), toLower(item.name)

	# 		first = slice 0, index, item.name
	# 		middle = slice index, index + autoCompleteText.length, item.name
	# 		last = slice index + autoCompleteText.length, item.name.length, item.name

	# 		div {style, key:item.name},
	# 			span {}, first
	# 			span {style: {fontWeight: 'bold'}}, middle
	# 			span {}, last



module.exports = Radium AutoCompleteDemo


