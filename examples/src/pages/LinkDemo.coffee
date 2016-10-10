React = require 'react'
Radium = require 'radium'
EventListener = require 'fbjs/lib/EventListener'
{div, h2, h4, p, br} = React.DOM
Link = React.createFactory require 'yun-ui-kit/Link'
Card = React.createFactory require 'yun-ui-kit/Card'
{always, assoc, dissoc, has, ifElse, merge, where} = R = require 'ramda' #auto_require:ramda
{mergeOrEvolve} = require 'ramda-extras'

LinkDemo = Radium React.createClass
	displayName: 'LinkDemo'

	getInitialState: ->
		dummyRerender: null

	componentWillMount: ->
		EventListener.listen window, 'popstate', =>
			# We must trigger a rerender for Links to be rerendered based on the
			# current query. Normal you'd do an app.set .. after a popstate.
			@setState {dummyRerender: Date.now()}

	render: ->
		div {},
			h2 {}, 'Link'
			h4 {}, 'Functionality'
			Card {},
				p {}, "The link components 2 major functions:"
				p {}, "1. It lets you change the current query string using simple
				transformation functions that operates on data, not a string.
				In the examples below we are using assoc,
				dissoc, mergeOrEvolve and always. If you want more details of how
				this works, have a look at yun/src/utils/url.coffee where
				helper-functions that Link.coffee uses are located."
				p {}, "2. It performs \"modern\" navigates using pushstate instead
				of just being links. This is done in a nice way that still let's
				the a tag have and href attribute and does not break right-clicks
				and similar things. See helper-funcitons in url.coffee for details."
				p {}, "The following links are dummies, they change the
				query in the url but they don't actually do what is said in the link
				text. They are just provided as examples for what you'd typically use
				a link for."
				br()
				Link {to: assoc('showPopup', true)}, 'Open popup'
				br()
				Link {to: dissoc('showPopup')}, 'Close popup'
				br()
				Link {to: mergeOrEvolve({something: [true, R.not]})}, 'Toggle something'
				Link {to: mergeOrEvolve({something: [true, R.not]})}, 'Toggle something'
				br()
				Link {to: ifElse has('something'), dissoc('something'), merge({something: true})},
					'Toggle something only showing if it\'s true'
				br()
				Link {to: always({})}, 'Clear'
				br()
				Link {to: always({page: 'Logout'})}, 'Clear and change page'

module.exports = LinkDemo
