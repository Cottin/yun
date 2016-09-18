{PropTypes: {func, shape, bool, oneOf, number}} = React = require 'react'
{div} = React.DOM
{always, bind, dec, filter, inc, isNil, length, pick, without} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'

browserUtils = require './utils/browserUtils'
domUtils = require './utils/domUtils'
{build: _} = require './utils/reactUtils'

# Popover = require './Popover'
EventListener = require './helpers/EventListener'

module.exports = React.createClass
	displayName: 'AutoCompleteRaw'

	propTypes:
		renderInput: func
		renderPopover: func
		selectedIndex: number
		requestChangeSelectedIndex: func
		requestClose: func
		pick: func
		canSelectWithTab: bool
		# filter: func

		# popover: shape
		# 	isOpen: bool
		# 	placement: oneOf(popoverUtils.PLACEMENTS)
		# 	onRequestClose: func
		# 	showArrow: bool
		# 	anchorMargin: number
		# 	viewportMargin: number

	render: ->
		{renderInput, renderPopover} = @props

		div {},
			renderInput @getDefaultInputProps()
			renderPopover()
			# renderList()
			# _ EventListener,
			# 	element: window
			# 	onWheel: (e) =>
			# 		# Research around this concludes you cannot cancel the scroll event
			# 		# but you can cancel the events provoking the scroll event
			# 		# http://stackoverflow.com/questions/4770025/how-to-disable-scrolling-temporarily
			# 		# http://stackoverflow.com/questions/8813051/determine-which-element-the-mouse-pointer-is-on-top-of-in-javascript
			# 		debugger

			# 		hoveredElement = document.elementFromPoint(e.clientX, e.clientY)
			# 		if isNil hoveredElement then return

			# 		popoverElement = @refs['popover']
			# 		if isNil popoverElement then return 

			# 		if domUtils.isDescendant hoveredElement, popoverElement
			# 			e.preventDefault()

	getDefaultInputProps: ->
		# onFocus: @onInputFocusDefault
		# onBlur: @onInputBlurDefault
		onKeyDown: @onInputKeyDownDefault
		ref: 'input'

	# onInputFocusDefault: (e) ->
	# 	# there is no state so you need to bind this
	# 	@setState {anchorEl: e.currentTarget, isOpen: true, selectedIndex: 0}

	# onInputBlurDefault: ->
	# 	@setState {anchorEl: null, isOpen: false, selectedIndex: null}

	onInputKeyDownDefault: (e) ->
		{ENTER, ESC, UP, DOWN, TAB} = browserUtils.keyCodes
		
		switch e.keyCode
			when ENTER then @props.pick()
				# without this check, pressing enter twice always selects the top of the list
				# if !@state.isItemSelected then @pick @state.indexOfFocusedItem
			when ESC then @props.requestClose('escape', e)
			when UP
				newIndex = Math.max dec(@props.selectedIndex), 0
				didChange = @props.requestChangeSelectedIndex newIndex
				if !didChange then return

				# instead of messing with scrollHeights we do a focus on the item and
				# then focus back on the input to get the browser to scroll
				@refs["item_#{newIndex}"]?.focus?()
				@refs.input?.focus?()
				# up arrow by default moves cursor in input to start, so we prevent it
				e.preventDefault()
			when DOWN
				newIndex = Math.min inc(@props.selectedIndex), length(@props.items)-1
				didChange = @props.requestChangeSelectedIndex newIndex
				if !didChange then return

				@refs["item_#{newIndex}"]?.focus?()
				@refs.input?.focus?()
				# down arrow by default moves cursor in input to end, so we prevent it
				e.preventDefault()
			when TAB
				if @props.canSelectWithTab then @props.pick()

	getInput: ->
		return @refs.input
		
