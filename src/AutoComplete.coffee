{PropTypes: {func, object}} = React = require 'react'
{div, input} = React.DOM
{flip, merge, props, test} = require 'ramda' #auto_require:ramda
{mapIndexed} = require 'ramda-extras'

domUtils = require './utils/domUtils'
{build: _} = require './utils/reactUtils'

AutoCompleteRaw = require './AutoCompleteRaw'
Popover = require './Popover'


# todo: move to ramda-extras
ymapIndexed = flip mapIndexed

module.exports = React.createClass
	displayName: 'AutoComplete'

	propTypes:
		renderItem: func
		filterItems: func
		onPicked: func
		inputProps: object
		popoverProps: object

	getDefaultProps: ->
		onPicked: -> null
		filterItems: -> []

	getInitialState: ->
		anchorEl: null
		isOpen: false
		selectedIndex: null
		filteredItems: []

	render: ->
		_ AutoCompleteRaw,
			renderInput: @renderInput
			renderPopover: @renderPopover
			ref: 'raw'

	renderInput: (defaultInputProps) ->
		# props = ymap defaultInputProps, (f) => f.bind(@)
		props_ = merge defaultInputProps,
			onChange: @onInputChange
			onFocus: @onInputFocus
			onBlur: @onInputBlur

		props__ = merge props_, @props.inputProps
		input props__

	onInputChange: (e) ->
		filteredItems = @props.filterItems e.currentTarget.value
		@setState {filteredItems}

	renderPopover: ->
		props =
			anchorEl: @state.anchorEl
			isOpen: @state.isOpen
			ref: 'popover'
			onRequestClose: @onRequestPopoverClose

		props_ = merge props, @props.popoverProps

		console.log 'AutoComplete popover props', props_
		_ Popover, props_,
			# div {}, 'test'
			div {style: {overflow: 'scroll', maxHeight: 'inherit'}},
				ymapIndexed @state.filteredItems, @renderItemCaller

	renderItemCaller: (item, i) ->
		props = {key: i, tabIndex: -1, ref: "item_#{i}}"}
		@props.renderItem props, item, i

	onRequestPopoverClose: (reason, e) ->
		if reason == 'clickAway'
			inputEl = @refs.raw?.getInput()
			# if we are clicking the input, we don't want to close
			if inputEl && domUtils.isDescendant(inputEl, e.target)
				return

		@setState {isOpen: false}

	onInputFocus: (e) ->
		@setState {anchorEl: e.currentTarget, isOpen: true, selectedIndex: 0}

	onInputBlur: ->
		@setState {anchorEl: null, isOpen: false, selectedIndex: null}







