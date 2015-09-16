{evolve, keys, pick} = require 'ramda' #auto_require:ramda
{cc, yforEach} = require 'ramda-extras'
lo = require 'lodash'

# Evolves the state of the component according to spec (optional cb)
evolveState = (component, spec, cb) ->
	state = pick keys(spec), component.state
	component.setState evolve(spec, state), cb

# Evolves the state of the component according to spec (optional cb)
mergeState = (component, spec, cb) ->
	stateCopy = lo.cloneDeep component.state
	component.setState lo.merge(stateCopy, spec), cb

adjustState = (component, f, cb) ->
	result = f component.state
	component.setState result, cb

module.exports = {evolveState, mergeState, adjustState}
