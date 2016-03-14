React = require 'react'
Radium = require 'radium'
{merge, none, props, test} = require 'ramda' #auto_require:ramda
{a} = React.DOM


# COMPONENTS ##################################################################

build = (comp, props, children...) ->
	debugger
	return React.createElement comp, props, children...

##### LINK 
Link_ = React.createFactory require '../views/Link'
# Link_ = require '../views/Link'

LinkStyle =
	color: 'red'
	
Link = Radium React.createClass
	displayName: 'LinkThemeMaterialDesign'
	render: ->
		# a {}, 'test2'
		Link_ merge({theme: LinkStyle}, @props), @props.children
		# build Link_, {theme: LinkStyle}, @props.children

# Link.style = LinkStyle


# GLOBAL ##################################################################
modernElement =
	display: 'flex'
	position: 'relative'
	flexDirection: 'column'
	flexShrink: 0 # weird behaviour with right margin on rootView on small screens
	userSelect: 'none'
	margin: 0
	padding: 0
	alignItems: 'stretch'

GlobalRules =
	body: merge modernElement,
		margin: 0,
		padding: 0
		fontFamily: 'proxima-nova, Helvetica Neue, Helvetica, Arial, sans-serif'
		color: '#464646'
		fontSize: '0.9em'
	html: merge modernElement,
		margin: 0,
		padding: 0
		background: '#EDEDE5'
	'*':
		boxSizing: 'border-box'

	button: modernElement
	header: modernElement
	section: modernElement
	nav: modernElement
	li: modernElement
	div: modernElement

	h1:
		fontWeight: 600
		fontSize: '1.30rem'
		marginTop: 0
		color: '#4D4D4D'

	h3:
		fontWeight: 500
		fontSize: '1.0rem'
		marginTop: 0
		color: '#666666'

	# Common util classes
	'.no-scroll':
		overflow: 'hidden'

module.exports = {Link, GlobalRules}
