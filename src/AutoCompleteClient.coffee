{PropTypes: {func, object, bool, shape, arrayOf, any, string, number}} = React = require 'react'
{div, input} = React.DOM
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'
{all, any, empty, filter, merge, pick, props, set, test} = require 'ramda' #auto_require:ramda
{yfilter} = require 'ramda-extras'
deepMerge = require 'lodash/merge'

{build: _} = reactUtils = require './utils/reactUtils'

AutoComplete = require './AutoComplete'

Item = React.createClass
	displayName: 'Item'

	mixins: [PureRenderMixin]

	propTypes:
		text: string

	focus: ->
		ReactDOM.findDOMNode(this).focus()

	render: ->
		{text, isSelected} = @props
		if isSelected
			style = {background: 'lightblue', cursor: 'pointer'}
		else
			style = {cursor: 'pointer'}
		props_ = merge @props, {style}
		# in order for the browser to scroll to the element being .focus()-ed
		# we need to set tabIndex
		div props_, @props.text


# Stateful AutoComplete component, ie. all state handled in parent.
module.exports = React.createClass
	displayName: 'AutoCompleteClient'

	propTypes:
		# Array of non-filtered-items
		items: arrayOf(any).isRequired
		# Predicate taking the entered text and an item. (text, item) -> bool
		filter: func
		# Function to render an item in the list of items. 
		# Signature: (defaultProps: object, item: any) -> Element
		renderItem: func
		# Function to render the input section.
		# Signature: (defaultProps: object) -> Element
		renderInput: func
		# Function to render the content in the popover if items is empty.
		# Signature: () -> Element
		renderEmpty: func

		# Callback when user picks an item
		onPicked: func

		# Properties for the Popover component (which is a child of AutoComplete)
		popover: shape
			# These props are sent directly as props to the Popover component
			# ie. make sure to atleast put isOpen and anchorEl here
			props: object
			# The style of the component inside the Popover that wraps its content
			style: object
			# The class of the component inside the Popover that wraps its content
			className: object

		# If user scrolls in popover and reaches edge of scroll, this prevents
		# the scrolling to bubble up and continue in the parent
		shouldBlockScroll: bool
		# If true, the user is allowed to pick and item using the tab key
		canPickWithTab: bool

	getDefaultProps: ->
		filter: (text, item) -> test new RegExp("^#{text}", 'i'), item
		renderItem: (props, item) -> _ Item, merge(props, {text: item})
		renderInput: (defaultProps) -> input defaultProps
		renderEmpty: -> div {}, 'No matches found'

	getInitialState: ->
		anchorEl: null
		isOpen: false
		filteredItems: @filterItems ''
		text: ''
		selectedIndex: null

	render: ->
		_ AutoComplete,
			items: @state.filteredItems
			renderItem: @props.renderItem
			renderInput: (defaultProps) =>
				@props.renderInput merge(defaultProps, {
					value: @state.text,
					onChange: @onInputChange
				})
			renderEmpty: @props.renderEmpty
			onPicked: @onPicked
			text: @state.text
			canPickWithTab: @props.canPickWithTab
			onRequestOpen: (e) =>
				@setState {isOpen: true, anchorEl: e.currentTarget}
			onRequestClose: (reason) =>
				if reason == 'blur'
					@props.onPicked(null)
					@setState {text: null}
				@setState {isOpen: false, anchorEl: null}
			selectedIndex: @state.selectedIndex
			onRequestSelectedIndexChange: (newIndex) =>
				@setState {selectedIndex: newIndex}
			popover: deepMerge @props.popover,
				props:
					anchorEl: @state.anchorEl
					isOpen: @state.isOpen

	onInputChange: (e) ->
		if !@state.isOpen
			@setState {isOpen: true, anchorEl: e.currentTarget}
		@setState
			text: e.currentTarget.value
			selectedIndex: 0
			filteredItems: @filterItems(e.currentTarget.value)

	onPicked: (item) ->
		@setState {text: item, filteredItems: @filterItems(item)}
		@props.onPicked item

	filterItems: (text) ->
		return yfilter @props.items, (item) => @props.filter(text, item)


