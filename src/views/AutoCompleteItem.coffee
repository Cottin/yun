React = require 'react'
{indexOf, last, slice, test, toLower} = require 'ramda' #auto_require:ramda
{div, span} = React.DOM

AutoCompleteItem = React.createClass
	displayName: 'AutoCompleteItem'

	render: ->
		{item, extractItemText, isSelected, autoCompleteText} = @props

		style =
			backgroundColor: if isSelected then '#f5f5f5'
			padding: '4px'

		itemText = extractItemText item
		if ! test RegExp(autoCompleteText, 'i'), itemText
			div {style, key:itemText},
				span {}, itemText
		else
			index = indexOf toLower(autoCompleteText), toLower(itemText)

			first = slice 0, index, itemText
			middle = slice index, index + autoCompleteText.length, itemText
			last = slice index + autoCompleteText.length, itemText.length, itemText

			div {style, key:itemText},
				span {}, first
				span {style: {fontWeight: 'bold'}}, middle
				span {}, last

module.exports = AutoCompleteItem
