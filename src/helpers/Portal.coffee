React = require 'react'
{func} = React.PropTypes
ReactDOM = require 'react-dom'
{div} = React.DOM
{any, isNil} = require 'ramda' #auto_require:ramda

# much inspired by https://github.com/callemall/material-ui/blob/master/src/internal/RenderToLayer.js

Portal = React.createClass
	propTypes:
		renderFn: func.isRequired

	componentDidMount: ->
		@renderLayer()

	componentDidUpdate: ->
		@renderLayer()

	componentWillUnmount: ->
		@unrenderLayer()

	render: -> null

	renderLayer: ->
		{renderFn} = @props

		if !@layer
			@layer = document.createElement 'div'
			# important to have position initial since if it is relative any node
			# returned from renderFn() that is absolute position will be absolute
			# relative to the @layer div and since that is added to the end
			# of the body node, the absolute node will be at the very bottom of
			# the page
			@layer.style.position = 'initial'
			document.body.appendChild @layer

			# By calling this method in componentDidMount() and
			# componentDidUpdate(), you're effectively creating a "wormhole" that
			# funnels React's hierarchical updates through to a DOM node on an
			# entirely different part of the page.

		layerElement = renderFn()

		if isNil layerElement
			# comments on unstable_renderSubtreeIntoContainer
			# https://twitter.com/sebmarkbage/status/694285706827399168
			# https://twitter.com/soprano/status/679814652172189696
			@layerElement = ReactDOM.unstable_renderSubtreeIntoContainer @, null, @layer
		else
			@layerElement = ReactDOM.unstable_renderSubtreeIntoContainer @, layerElement, @layer

	unrenderLayer: ->
		if !@layer then return

		ReactDOM.unmountComponentAtNode @layer
		document.body.removeChild @layer
		@layer = null

	getLayer: -> @layer

module.exports = Portal
