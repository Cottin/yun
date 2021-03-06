{T, any, curry, evolve, isNil, keys, mapObjIndexed, merge, over, pick, prop, props, type} = R = require 'ramda' #auto_require:ramda
{cc, yforEach} = require 'ramda-extras'
lo = require 'lodash'
React = require 'react'

# Evolves the state of the component according to spec (optional cb)
exports.evolveState = evolveState = (component, spec, cb) ->
	state = pick keys(spec), component.state
	component.setState evolve(spec, state), cb

# Evolves the state of the component according to spec (optional cb)
exports.mergeState = mergeState = (component, spec, cb) ->
	stateCopy = lo.cloneDeep component.state
	component.setState lo.merge(stateCopy, spec), cb

exports.adjustState = adjustState = (component, f, cb) ->
	result = f component.state
	component.setState result, cb

# Is this really needed?
# Why no only do {createElement: _} = React = require 'react'
# comp, obj, [comp] -> comp
# takes care of the React.createFactory dance for you
# exports.build = build = (comp, props, children...) ->
# 	return React.createElement comp, props, children...

# IDEAS THAT DIDN'T PAN OUT ----------------------------
# exports.xbuild = build = (comp, style, props, children...) ->
# 	console.log {comp}, typeof(comp), {type: comp.type}
# 	if R.is String, comp.type 
# 		comp = comp.type

# 	if isNil style
# 		return React.createElement comp

# 	if !style.__isStyle
# 		return React.createElement comp, style, [props, children...]

# 	enhancedProps = merge props,
# 		dataStyleName: style.__styleName

# 	return React.createElement comp, enhancedProps, children...

# exports.Pure = Pure = (displayName, propTypes, render) ->
# 	return React.createClass
# 		displayName: displayName
# 		propTypes: propTypes
# 		render: -> render this.props

# exports.style = style = (spec) ->
# 	addName = (v, k) -> merge {__styleName: k}, v
# 	merge mapObjIndexed(addName, spec), {__isStyle: true}
# ------------------------------------------------------

# o -> o -> o -> o
# Helps implements the "theme-pattern" which works as follows:
# A component typically have a default styling (componentStyle), but
# you can override this by require-ing it and modify it however you want.
# You then need to supply the modified object as the 'theme' prop to the
# component which in turn will use that theme as it's base style instead
# of its default styling. Any extra style supplied to the component via
# the 'style' prop will be merged over the base theme.
# This utility-function helps you to implement this pattern in a component
# and makes sure there is only one way component implements this pattern.
# e.g.	componentStyle = require './MyComponent.style'
#				propsToUse = propsUsingTheme componentStyle, @props
exports.applyTheme = applyTheme = curry (componentStyle, props) ->
	# use supplied theme from props or, if not supplied, componentStyle
	baseStyle = props.theme || componentStyle
	# merge baseStyle with any special style supplied as prop
	extraStyle = props.style || {}
	return merge {style: merge(baseStyle, extraStyle)}, props
