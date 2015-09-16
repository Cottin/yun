{__, all, call, curry, has, keys, last, mapObjIndexed, merge, omit, type} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'
lo = require 'lodash'

# Returns a new function. Calling it with args will call all fs with args.
callAll = (fs...) -> ->
	results = for f in fs
		f.apply null, arguments
	return last results

# The name says it all, merges nicely :)
# NOTE: it might be easier to implement a niceMerge using lodashes merge.
niceMerge = curry (a, b) ->
	if !b then return a
	mergeWithB = (v, k) ->
		if has k, b
			switch type v
				when 'Function' then callAll v, b[k]
				else b[k]
		else v
	bDifferenceA = omit keys(a), b
	return cc merge(__, bDifferenceA), mapObjIndexed(mergeWithB), a

module.exports = {callAll, niceMerge}
