React = require 'react'
Radium = require 'radium'
{both} = require 'ramda' #auto_require:ramda
{mergeMany} = require 'ramda-extras'
{div} = React.DOM

# This awesome spinner is created by Tobias Ahlin
# https://github.com/tobiasahlin/SpinKit/blob/master/examples/7-three-bounce.html

container =
  flexDirection: 'row'

bounceKeyframes = Radium.keyframes
  '0%': {transform: 'scale(0)'}
  '40%': {transform: 'scale(1)'}
  '80%': {transform: 'scale(0)'}
  '100%': {transform: 'scale(0)'}

ball =
  # width: 15   these two are handled by size
  # height: 15
  backgroundColor: '#333'
  borderRadius: '100%'
  marginRight: 7
  display: 'inline-block'
  animation: "#{bounceKeyframes} 1.4s ease-in-out 0s infinite both"

delay1 =
  animationDelay: '-0.32s'

delay2 =
  animationDelay: '-0.16s'

SpinnerBalls = React.createClass
	displayName: 'SpinnerBalls'

	propTypes:
		size: React.PropTypes.number

	getDefaultProps: ->
		size: 15

	render: ->
		size = {width: @props.size, height: @props.size}
		div {style: container},
      div {style: mergeMany ball, delay1, size}
      div {style: mergeMany ball, delay2, size}
      div {style: mergeMany ball, size}

module.exports = Radium SpinnerBalls
