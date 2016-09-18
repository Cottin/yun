React = require 'react'
{add, call, isNil, mapObjIndexed, omit, props} = R = require 'ramda' #auto_require:ramda
{number, array, object, bool} = React.PropTypes

loopThroughEvents = (props, cb) ->
	# destructuring with splats in coffee... hopefully soon :(
	rest = omit ['element', 'delayRegistration', 'setInterval'], props
	register = (eventCallback, onEvent) ->
		event = onEvent.substring(2).toLowerCase()
		cb event, eventCallback

	mapObjIndexed register, rest

# Instead of doing the didMount/willUnmount dance, EventListener lets you
# add listeners declaratively.
# stolen from: https://github.com/oliviertassinari/react-event-listener
EventListener = React.createClass
	displayName: 'EventListener'

	propTypes:
		element: object # eg. window
		delayRegistration: number # milli seconds
		# If you also want a general setInterval.
		# [callback, interval, (optional) initialCall]
		# initialCall can be true (call directly on registration)
		# 						or a number (do a window.setTimeout with that number)
		setInterval: array 


	componentDidMount: ->
		{element, delayRegistration, setInterval} = @props
		register = => 
			loopThroughEvents @props, (event, cb) ->
				element.addEventListener event, cb

		if isNil delayRegistration then register()
		else window.setTimeout register, delayRegistration

		if setInterval
			[cb, ms, initialCall] = setInterval
			@_intervalId = window.setInterval cb, ms
			if initialCall == true then cb()
			else if R.is(Number, initialCall)
				window.setTimeout cb, initialCall

	componentWillUnmount: ->
		{element} = @props
		loopThroughEvents @props, (event, cb) ->
			element.removeEventListener event, cb

		if @_intervalId then window.clearInterval @_intervalId

	render: -> null	

module.exports = EventListener
