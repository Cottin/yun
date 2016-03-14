{PropTypes: {string, func, object, oneOfType}} = React = require 'react'
Radium = require 'radium'
{all, any, merge, omit, props} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'
{a} = React.DOM
{createUrlHelper, nav} = require '../utils/url'
{applyTheme} = require '../utils/react'


Link = Radium React.createClass
	displayName: 'Link'

	propTypes:
		to: oneOfType([func, object, string])
		href: string # if href is used, will behave like a "dumb" link
		theme: object
		# NOTE: this component will transfer all props you supply to it's child

	render: ->
		{to, href} = @props
		omitSpecialProps = omit ['to', 'theme']
		# null supplied since Link doesn't have any default component style
		otherProps = cc applyTheme(null), omitSpecialProps, @props
		if href then return a otherProps
		
		href = createUrlHelper to
		linkProps = {href, onClick: nav(href)}
		a merge(linkProps, otherProps)

module.exports = Link
