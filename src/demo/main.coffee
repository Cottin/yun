
React = require 'react/addons'
AppView = React.createFactory require('./AppView')

{forEach, keys} = R = require 'ramda'

install = (o, target) ->
	addKey = (k) -> target[k] = o[k]
	forEach addKey, keys o

originalIsNaN = window.isNaN
install {R}, window
install R, window
window.isNaN = originalIsNaN

ramdaExtras = require 'ramda-extras'
install {ramdaExtras}, window
install ramdaExtras, window

moment = require 'moment'
install {moment}, window

data = require './data'
install {data}, window

utils = require '../utils/utils'
install {utils}, window

install {React}, window


React.render AppView(), document.getElementById('root')
