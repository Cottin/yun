React = require 'react'

AutoComplete = require '../../views/AutoComplete'

GlobalRules =
	body:
		margin: 0,
		fontFamily: 'sans-serif'
	'*':
		boxSizing: 'border-box'

module.exports = {GlobalRules, AutoComplete}
