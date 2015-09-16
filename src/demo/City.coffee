React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
{indexOf, last, props, slice, test, toLower} = require 'ramda' #auto_require:ramda
{div, span} = React.DOM

City = React.createClass
	displayName: 'City'

	mixins: [PureRenderMixin]

	render: ->
		{item, isSelected, autoCompleteText} = @props
		# TODO: could try to move some of this to willReceive props instead
		#				but then we'd have to used state for first, middle and last

		style =
			backgroundColor: if isSelected then '#f5f5f5'
			padding: '4px'
			flexDirection: 'row'

		if ! test RegExp(autoCompleteText, 'i'), item.name
			div {style, key:item.name}, item.name
		else
			index = indexOf toLower(autoCompleteText), toLower(item.name)

			first = slice 0, index, item.name
			middle = slice index, index + autoCompleteText.length, item.name
			last = slice index + autoCompleteText.length, item.name.length, item.name

			div {style, key:item.name},
				span {}, first
				span {style: {fontWeight: 'bold'}}, middle
				span {}, last

module.exports = City
