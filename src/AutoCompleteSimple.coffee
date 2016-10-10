{PropTypes: {}} = React = require 'react'
{build: _} = require './utils/reactUtils'
AutoComplete = require './AutoComplete'

module.exports = React.createClass
	displayName: 'AutoCompleteSimple'

	propTypes:
		isInitiallyOpen: bool
		initialText: bool

	getInitialState: ->

	render: ->
		_ AutoComplete
