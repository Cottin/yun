{assoc, dissoc, either, has, identity, ifElse, inc, join, map, pair, remove, toPairs, type, values, without} = R = require 'ramda' #auto_require:ramda
{cc, isEmptyObj, mergeOrEvolve} = require 'ramda-extras'

# -> {k:v}   # returns current query string as object
# http://stackoverflow.com/questions/647259/javascript-query-string
getQuery = ->
	result = {}
	queryString = location.search.slice(1)
	re = /([^&=]+)=([^&]*)/g
	m = undefined
	while m = re.exec(queryString)
		v = decodeURIComponent(m[2])

		# some simple parsing
		value = switch
			when v == 'true' then true
			when v == 'false' then false
			else v

		result[decodeURIComponent(m[1])] = value
	return result

# -> s   # Returns current url without query string
# http://stackoverflow.com/a/5817566/416797
urlWithoutQuery = -> [location.protocol, '//', location.host, location.pathname].join('')

# [k, v] -> s
# Takes a key value pair and returns their query string representation
_kvToQuery = ([k, v]) -> "#{k}=#{v}"

# o -> s
# Takes an object with key-values and returns it's "query string equivalent"
# e.g. toQueryString {page: 'login', user: 'Max'} returns '?page=login&user=Max'
toQueryString = (o) -> '?' + cc join('&'), map(_kvToQuery), toPairs, o

# {f, o, s} -> s
# Returns an url (string) that for instance can be used in an a-tag as href.
# The returned url is constructed by applying f to the current query or doing
# a mergeEvolve on it using spec.
# e.g.
#   invoke with function f:
#    "remove":	createUrl dissoc('small')
#               given '/?stats=true&small=true' returns '/?stats=true' 
#    "toggle":	createUrl ifElse(has('small'), dissoc('small'), assoc('small', true))
#								given '/?small=true' returns '/?small=false'
#								given '/?' returns '/?small=true' 
#
#		invoke with object spec:
#     "inc":    createUrl {count: inc}
#               given '/?count=1' returns '/?count=2'
createUrl = ({f, spec, url}) ->
	urlToUse = url || urlWithoutQuery()
	if f
		return urlToUse + toQueryString(f(getQuery()))
	else if spec
		newQuery = mergeOrEvolve spec, getQuery()
		return urlToUse + toQueryString(newQuery)
	else throw Error 'createUrl must be called with either f or spec'

# (s|f|o) -> s
# Helper that provides a polymorphic interface to createUrl.
# Note that if called with a string, this functions assumes you've already
# constructed the desired url and therefore just returns it. If you whish
# to use the "url" argument of createUrl, use that function directly.
createUrlHelper = (urlOrFnOrObj) ->
	if R.is String, urlOrFnOrObj then urlOrFnOrObj
	else if R.is Function, urlOrFnOrObj then createUrl {f: urlOrFnOrObj}
	else if R.is Object, urlOrFnOrObj then createUrl {spec: urlOrFnOrObj}

# (s|f|o) -> null
# Does a "modern" navigate using pushState and dispatchEvent.
# For more information on urlOrFnOrObj see createUrlHelper.
navigate = (urlOrFnOrObj) ->
	url = createUrlHelper urlOrFnOrObj
	# idea from https://github.com/larrymyers/react-mini-router/blob/master/lib/navigate.js
	window.history.pushState {}, '', url
	window.dispatchEvent new window.Event('popstate')
	return null # return null to work around warning, see navigateCallback


##### CALLBACK UTILS ##########################################################

# o -> bool	 # returns true if user clicked using left mouse
# stolen from https://github.com/rackt/react-router/blob/master/modules/Link.js
_isLeftClickEvent = (e) -> e.button == 0

# o -> bool	 # returns true if user clicked while modifier was pressed
_isModifiedEvent = (e) -> !!(e.metaKey || e.altKey || e.ctrlKey || e.shiftKey)

# o -> undefined	 Shorthand to stop propagation
stop = (e) -> e.stopPropagation()

# (s|f|o) -> f(e) -> e
# Returns a callback to use for onClick in a(href) elements. Does a "modern"
# navigate using pushState.
# For more information on urlOrFnOrObj see createUrlHelper.
nav = (urlOrFnOrObj) -> (e) ->
	# if a user clicks with the mouse-wheel or using e.g. cmd + click
	# we have to abord and let the browser open that link in a new tab / window
	if _isModifiedEvent(e) || !_isLeftClickEvent(e) then return e

	navigate createUrlHelper urlOrFnOrObj 
	e.preventDefault()
	# if we return false or true we get error msg from react
	# 'Warning: Returning `false` from an event handler is deprecated'
	return e # ..so we're returning the event

# (s|f|o) -> f(e) -> null
# NOTE: To get standard web behaviour, you should use links and the nav function.
#				If you anyway want to navigate somewhere when clicking a button or similar,
#				this function could be used as some kind of onClick handler.
# Does a "modern" navigate using pushState and dispatchEvent.
# For more information on urlOrFnOrObj see createUrlHelper.
nav2 = (urlOrFnOrObj) -> (e) ->
	e.stopPropagation()
	navigate createUrlHelper urlOrFnOrObj 
	return null # return null to work around warning, see navigateCallback

module.exports = {getQuery, urlWithoutQuery, createUrl, createUrlHelper, navigate,
nav, nav2, stop}

## ideas that were removed but might be used later: ----------------------------------------
# # :: {url, f} -> {k:v}
# # returns a new url based on passed url or current url and f applied to current query
# adjustUrl = ({url, f}) ->
# 	urlToUse = url || urlWithoutQuery()
# 	if f then newQuery = cc toQueryString, f, getQuery()
# 	return urlToUse + (newQuery || getQuery())


# # (s|f|o) -> s
# # Returns an url (string) that for instance can be used in an a-tag as href.
# # Note that this doesn't do anything with push-state, it just returns a string.
# # urlOrFnOrObj can be called with either a string, a function or an object and
# # simply speaking does an "identity", "function application" or "mergeOrEvolve"
# # e.g.
# # 	invoke with string:   href '/profile'    returns '/profile'
# #
# #   invoke with function:
# #    "remove":	href dissoc('small')
# #               returns '/?stats=true' given '/?stats=true&small=true'
# #    "toggle":	href ifElse(has('small'), dissoc('small'), assoc('small', true))
# #								returns '/?small=false' given '/?small=true'
# #								returns '/?small=true' given '/?'
# #
# #		invoke with object: 
# #     "inc":    href {count: inc}
# #               returns '/?count=2' given '/?count=1'
# # TODO: ta bort fallet sträng. I det fallet får man inse det själv och inte kalla på den här funktionen, kanske något sånt här
# # createUrl = ({f, spec, url}) -> dvs, en blandning mellan det här och adjustUrl
# createUrl = (urlOrFnOrObj) ->
# 	if R.is String, urlOrFnOrObj then return urlOrFnOrObj
# 	if R.is Function, urlOrFnOrObj
# 		newQuery = urlOrFnOrObj getQuery()
# 		return urlWithoutQuery() + (toQueryString(newQuery) || '')
# 	else if R.is Object, urlOrFnOrObj
# 		newQuery = mergeOrEvolve urlOrFnOrObj, getQuery()
# 		return urlWithoutQuery() + (toQueryString(newQuery) || '')
# 	else throw Error "navigate must be called with arg of type
# 	(str | obj | func), got #{typeof urlOrFnOrObj}"
