{flatten, isEmpty, isNil, join, map, reject} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'

exports.prepareLooks = prapareLooks = (looks, style, theme) ->
	if isNil(looks) || isEmpty(looks) then return ''

	extract = (l) -> [style[l], theme[l]]
	return cc join(' '), reject(isNil), flatten, map(extract), looks
