{PropTypes: {func, object, bool, shape, arrayOf, any, string, number}} = React = require 'react'
{div, input} = React.DOM
{all, any, dec, empty, flip, inc, isEmpty, isNil, keys, length, merge, pick, props, take} = require 'ramda' #auto_require:ramda
{mapIndexed} = require 'ramda-extras'

domUtils = require './utils/domUtils'
browserUtils = require './utils/browserUtils'
{build: _} = require './utils/reactUtils'
blockScroll = require './helpers/blockScroll'

Popover = require './Popover'

# todo: move to ramda-extras
ymapIndexed = flip mapIndexed

scrollBlockedDiv = blockScroll(div)

# Stateless AutoComplete component, ie. all state handled in parent.
# This gives you flexibility to decide behaviour and rendering of the
# AutoComplete. But it comes at the price of having to do a lot in the parent.
# If you have a simple use case, take a look at AutoCompleteClient and
# AutoCompleteServer which provides you a simpler api (but less flexibility).
module.exports = React.createClass
	displayName: 'AutoComplete'

	propTypes:
		# Array of items (this should already be filtered by parent).
		items: arrayOf any
		# Function to render an item in the list of items. 
		# Signature: (defaultProps: object, item: any) -> Element
		renderItem: func
		# Function to render the input section.
		# Signature: (defaultProps: object) -> Element
		renderInput: func
		# Function to render the content in the popover if items is empty.
		# Signature: () -> Element
		renderEmpty: func

		# Index of currently selected item in items
		selectedIndex: number

		# Callback when user picks an item
		onPicked: func
		# Callback for when the component thinks the Popover should open
		onRequestOpen: func
		# Callback for when the component thinks the Popover should close
		onRequestClose: func
		# Callback for when the component things the selected index should change
		onRequestSelectedIndexChange: func

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
		shouldBlockScroll: true
		canPickWithTab: false
		popover: {}

	render: ->
		div {},
			@renderInput()
			@renderPopover()

	renderInput: () ->
		defaultProps =
			ref: 'input'
			onFocus: @onInputFocus
			onBlur: @onInputBlur
			onKeyDown: @onInputKeyDown

		@props.renderInput defaultProps

	renderPopover: ->
		props =
			ref: 'popover'
			onRequestClose: @onRequestPopoverClose

		props_ = merge props, (@props.popover.props || {})

		el = if @props.shouldBlockScroll then scrollBlockedDiv else 'div'
		style = merge {overflow: 'scroll', maxHeight: 'inherit'},
							(@props.popover.style || {})

		_ Popover, props_,
			_ el, {style, className: @props.popover.className},
				if isEmpty @props.items then @props.renderEmpty()
				else ymapIndexed @props.items, @renderItemCaller

	renderItemCaller: (item, i) ->
		# ref : needed to be able to focus on the item when reaching overflowed items
		# using the arrow keys (up / down).
		# tabIndex : needed by browsers to be able to focus on an item
		defaultProps = {key: i, tabIndex: -1, ref: "item_#{i}",
		isSelected: i == @props.selectedIndex,
		onMouseOver: @onItemMouseOver(i),
		onMouseDown: @onItemClick(i)}
		@props.renderItem defaultProps, item

	onItemMouseOver: (index) -> (e) =>
		@props.onRequestSelectedIndexChange? index

	onItemClick: (index) -> (e) =>
		@pickAndClose()

	onRequestPopoverClose: (reason, e) ->
		if reason == 'clickAway'
			inputEl = @refs.input
			# if we are clicking the input, we don't want to close
			if inputEl && domUtils.isDescendant(inputEl, e.target)
				return

		@props.onRequestClose?()

	onInputFocus: (e) ->
		if @___tryingToMakeBrowserScroll then return

		@props.onRequestOpen?(e)
		@props.onRequestSelectedIndexChange? 0

	onInputBlur: ->
		if @___tryingToMakeBrowserScroll then return
		@close('blur')

	onInputKeyDown: (e) ->
		{ENTER, ESC, UP, DOWN, TAB} = browserUtils.keyCodes

		{items, selectedIndex} = @props
		
		switch e.keyCode
			when ENTER then @pickAndClose()
			# when ESC
			# 	@close('escape')
			when UP
				newIndex = Math.max dec(selectedIndex), 0
				@props.onRequestSelectedIndexChange? newIndex

				# Instead of messing with scrollHeights we do a focus on the item and
				# then focus back on the input to get the browser to scroll.
				# We need this hacky flag to make sure not to trigger focus and blur
				@___tryingToMakeBrowserScroll = true
				@refs["item_#{newIndex}"]?.focus?()
				@refs.input.focus()
				@___tryingToMakeBrowserScroll = false
				# up arrow by default moves cursor in input to start, so we prevent it
				e.preventDefault()
			when DOWN
				newIndex = Math.min inc(selectedIndex), length(items)-1
				@props.onRequestSelectedIndexChange? newIndex

				@___tryingToMakeBrowserScroll = true
				@refs["item_#{newIndex}"]?.focus?()
				@refs.input.focus()
				@___tryingToMakeBrowserScroll = false
				# down arrow by default moves cursor in input to end, so we prevent it
				e.preventDefault()
			when TAB
				if !@props.canPickWithTab then return
				@pickAndClose()

	pickAndClose: ->
		if isNil @props.selectedIndex then return
		@props.onPicked(@props.items[@props.selectedIndex])
		@close('picked')

	close: (reason) ->
		@props.onRequestClose?(reason)
		@props.onRequestSelectedIndexChange? null

