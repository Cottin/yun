React = require 'react'
lo = require 'lodash'
Radium = require 'radium'
{flatten, identity, keys, merge, mergeAll, none, pick, pickBy, props, split, values} = require 'ramda' #auto_require:ramda
{pathOr} = require 'ramda-extras'
{input, a} = React.DOM

AutoComplete_ = React.createFactory require '../../views/AutoComplete'
{inputStyle, popupStyle, sidebarStyle} = require './AutoCompleteKind.style'
KindInputStyle = require './KindInput.style'
KindButtonstyle = require './KindButton.style'
AutoCompleteItem = require '../../views/AutoCompleteItem'
SpinnerBalls_ = require '../../views/SpinnerBalls'

AutoComplete = React.createClass
	render: ->
		propInputStyle = pathOr {}, ['input', 'props', 'style'], @props
		changesToProps = 
			input:
				props:
					style: merge inputStyle, propInputStyle
			popup:
				style: merge popupStyle, @props.popup.style
			sidebar:
				style: merge sidebarStyle, @props.sidebar.style

		AutoComplete_ lo.merge(lo.cloneDeep(@props), changesToProps), @props.children

Input = Radium React.createClass
	render: ->
		{s, cs} = @props
		if s
			stylesToPick = if isa(String, s) then split('.', s) else s
			styles = cc values, pick(stylesToPick), KindInputStyle
		if cs
			ks = cc keys, pickBy(identity), cs # pick keys with true values
			stylesToPick = if isa(String, ks) then split('.', ks) else ks
			conditionalStyles = cc values, pick(stylesToPick), KindInputStyle
		allStyles = flatten [KindInputStyle.base, styles, conditionalStyles]
		defaultProps = {style: mergeAll(allStyles)}
		input lo.merge(defaultProps, @props), @props.children

Button = Radium React.createClass
	render: ->
		{s, cs} = @props
		if s
			stylesToPick = if isa(String, s) then split('.', s) else s
			styles = cc values, pick(stylesToPick), KindButtonstyle
		if cs
			ks = cc keys, pickBy(identity), cs # pick keys with true values
			stylesToPick = if isa(String, ks) then split('.', ks) else ks
			conditionalStyles = cc values, pick(stylesToPick), KindButtonstyle
		allStyles = flatten [KindButtonstyle.base, styles, conditionalStyles]
		defaultProps = {style: mergeAll(allStyles)}
		a lo.merge(defaultProps, @props), @props.children

SpinnerBalls = SpinnerBalls_

common =
	font:
		xxs: {fontSize: '0.50rem'}
		xs: {fontSize: '0.60rem'}
		s: {fontSize: '0.80rem'}
		m: {fontSize: '0.90rem'}
		l: {fontSize: '1.00rem'}
		xl: {fontSize: '1.10rem'}
		xxl: {fontSize: '1.20rem'}
		xxxl: {fontSize: '1.30rem'}
		xxxxl: {fontSize: '1.40rem'}

	panel:
		backgroundColor: '#fff'
		boxShadow: '0 1px 2px rgba(0, 0, 0, 0.1)'


modernElement =
	display: 'flex'
	position: 'relative'
	flexDirection: 'column'
	flexShrink: 0
	userSelect: 'none'
	margin: 0
	padding: 0
	alignItems: 'stretch'

GlobalRules =
	body: merge modernElement,
		margin: 0,
		fontFamily: 'proxima-nova, Times New Roman, Helvetica Neue, Helvetica, Arial, sans-serif'
		color: '#464646'
		fontSize: '0.9em'
	html: merge modernElement,
		background: '#EDEDE5'
	'*':
		boxSizing: 'border-box'

	button: modernElement
	header: modernElement
	section: modernElement
	nav: modernElement
	li: modernElement
	div: modernElement


module.exports = {GlobalRules, common, AutoComplete, AutoCompleteItem, Input, Button, SpinnerBalls}
