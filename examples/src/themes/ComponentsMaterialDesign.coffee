React = require 'react'
{merge} = require 'ramda' #auto_require:ramda

Dialog_ = React.createFactory require '../../views/Dialog'
Dialog_theme = require '../../themes/MaterialDesign/Dialog.css'
console.log Dialog_theme

exports.Dialog = Dialog = React.createClass
	displayName: 'DialogMaterialDesign'
	render: ->
		Dialog_ merge({theme: Dialog_theme}, @props)
