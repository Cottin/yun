React = require 'react'
ReactDOM = require 'react-dom'
recompose = require 'recompose'
{any, has, isNil, set} = R = require 'ramda' #auto_require:ramda

domUtils = require '../utils/domUtils'

# HOC that enhances any component that has overflow: scroll set so that when
# you reach the top or bottom of the scroll, the scroll event is prevented from
# bubbling up to scroll the whole screen. Might be nice for popups and modals.
# TODO: Make it work on touch devices
module.exports = (component) -> React.createClass
	displayName: recompose.wrapDisplayName component, 'blockScroll'

	componentDidMount: ->
		window.addEventListener 'wheel', @onWheel

	componentWillUnmount: ->
		window.removeEventListener 'wheel', @onWheel

	render: ->
		component @props

	onWheel: (e) ->
		hoveredElement = document.elementFromPoint e.clientX, e.clientY
		if isNil hoveredElement then return

		element = ReactDOM.findDOMNode(this)
		if isNil element then return

		if !domUtils.isDescendant element, hoveredElement then return

		{scrollTop, scrollHeight, offsetHeight} = element


		if e.deltaY < 0 # scroll up
			newScrollTop = scrollTop + e.deltaY
			if newScrollTop <= 0
				element.scrollTop = 0
				e.preventDefault()

		else if e.deltaY > 0 # scroll down
			newScrollTop = scrollTop + e.deltaY
			if newScrollTop >= scrollHeight - offsetHeight
				element.scrollTop = scrollHeight - offsetHeight
				e.preventDefault()



