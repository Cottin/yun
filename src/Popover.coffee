React = require 'react'
ReactDOM = require 'react-dom'
{bool, object, oneOf, bool, number, func} = React.PropTypes
{equals, isNil, merge, none, set, subtract} = require 'ramda' #auto_require:ramda
{div} = React.DOM
popoverUtils = require './utils/popoverUtils'
domUtils = require './utils/domUtils'
Portal = React.createFactory require './helpers/Portal'
EventListener = React.createFactory require './helpers/EventListener'

style =
	position: 'absolute'
	zIndex: 99999
	background: '#FFFFFF'
	border: '1px solid #D9D9D9'
	boxShadow: '0px 2px 6px 0px rgba(0,0,0,0.17)'

Popover = React.createClass
	propTypes:
		isOpen: bool
		anchorEl: object
		placement: oneOf(popoverUtils.PLACEMENTS)
		onRequestClose: func
		showArrow: bool
		anchorMargin: number
		viewportMargin: number

	getDefaultProps: ->
		isOpen: false
		anchorEl: null
		placement: 'bottom-center'
		onRequestClose: -> null
		showArrow: true
		anchorMargin: 8
		viewportMargin: 15

	renderPortal: ->
		div {style},
			@props.children

	render: ->
		{isOpen} = @props
		if !isOpen then return null

		console.log 'render EventListener'
		div {style: {display: 'none'}},
			EventListener
				element: window
				# setInterval: [@setPosition, 1000000, 0]
				# setInterval: [@setPosition, 1000]
				setInterval: [@setPosition, 10]
				onMouseDown: @onMouseDown
				onTouchStart: @onMouseDown
				# Without delaying registration, the same click that opened the popup
				# will also close it. We discussed this here:
				# https://github.com/oliviertassinari/react-event-listener/issues/3
				# Although, now we changed to onMouseDown instead and then this problem
				# disappears
				# delayRegistration: 0
			# 	onWheel: (e) =>
			# 		# Research around this concludes you cannot cancel the scroll event
			# 		# but you can cancel the events provoking the scroll event
			# 		# http://stackoverflow.com/questions/4770025/how-to-disable-scrolling-temporarily
			# 		# http://stackoverflow.com/questions/8813051/determine-which-element-the-mouse-pointer-is-on-top-of-in-javascript

			# 		hoveredElement = document.elementFromPoint(e.clientX, e.clientY)
			# 		if isNil hoveredElement then return

			# 		popoverEl = @refs.portal.getLayer().children[0]
			# 		firstChild = popoverEl.children[0]
			# 		window.popoverEl = popoverEl

			# 		if isNil popoverEl then return

			# 		if domUtils.isDescendant popoverEl, hoveredElement
			# 			null
			# 			# e.preventDefault()

			Portal {renderFn: @renderPortal, ref: 'portal'}

	onMouseDown: (e) ->
		if e.defaultPrevented then return
		if !@refs.portal then return
		if !@props.isOpen then return

		popoverEl = @refs.portal.getLayer().children[0]
		if domUtils.isDescendant(popoverEl, e.target) then return

		console.log('clickAway')
		@props.onRequestClose('clickAway', e)

	getArgs: ->
		{anchorEl, viewportMargin, anchorMargin, maxHeight, placement} = @props

		# todo: handle small screens
		if !anchorEl then throw new Error 'anchorEl not set'

		popoverEl = @refs.portal.getLayer().children[0]
		if !popoverEl then throw new Error 'popoverEl not found'

		popover = merge domUtils.getBoundingClientRectAsObj(popoverEl),
			scrollHeight: domUtils.getTotalScrollHeight popoverEl
			maxHeight: (maxHeight || 9999)
			scrollWidth: popoverEl.scrollWidth

		anchor = merge domUtils.getBoundingClientRectAsObj(anchorEl),
			margin: anchorMargin

		viewport =
			# note: innerHeight doesn't subtract scrollbars, ie. clientHeight
			height: window.document.documentElement.clientHeight
			width: window.document.documentElement.clientWidth
			scrollY: window.scrollY
			scrollX: window.scrollX
			margin: viewportMargin
			# note: I think scrollHeight is more correct than offsetHeight (and width) Seems lite not :)
			# scrollHeight: window.document.documentElement.scrollHeight
			# scrollHeight: window.document.documentElement.offsetHeight
			# scrollWidth: window.document.documentElement.offsetWidth
			# scrollWidth: window.document.documentElement.scrollWidth
			bodyHeight: window.document.documentElement.offsetHeight
			bodyWidth: window.document.documentElement.offsetWidth

		return {popoverEl, popover, anchor, viewport, placement}

	setPosition: ->
		if !@props.isOpen then return
		# todo:
		# if (@isFullScreen()) return // The fullscreen position is only calculated on render as it will not move around on the screen when scrolling.

		{popoverEl} = args = @getArgs()
		if isNil(args) || !@didChange args then return

		{top, bottom, left, right, maxHeight, maxWidth} = popoverUtils.calcPosition args
		# console.log 'result', {top, bottom, left, right, maxHeight, maxWidth}
		
		if top
			popoverEl.style.top = top + 'px'
			popoverEl.style.bottom = 'initial'
		else if bottom
			popoverEl.style.top = 'initial'
			popoverEl.style.bottom = bottom + 'px'

		if left
			popoverEl.style.left = left + 'px'
			popoverEl.style.right = 'initial'
		else if right
			popoverEl.style.left = 'initial'
			popoverEl.style.right = right + 'px'

		popoverEl.style.maxHeight = maxHeight + 'px'
		popoverEl.style.maxWidth = maxWidth + 'px'

	didChange: (result) ->
		isSame = equals result, @_lastResult
		@_lastResult = result
		return !isSame


module.exports = Popover
