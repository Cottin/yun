{join, map, toPairs} = require 'ramda' #auto_require:ramda
{isEmptyObj} = require 'ramda-extras'

# :: -> {k:v}   # returns current query string as object
# http://stackoverflow.com/questions/647259/javascript-query-string
getQuery = ->
  result = {}
  queryString = location.search.slice(1)
  re = /([^&=]+)=([^&]*)/g
  m = undefined
  while m = re.exec(queryString)
    result[decodeURIComponent(m[1])] = decodeURIComponent(m[2])
  return result

# :: -> s   # Returns current url without query string
# http://stackoverflow.com/a/5817566/416797
urlWithoutQuery = -> [location.protocol, '//', location.host, location.pathname].join('')

# :: f -> {k:v}
# Gets current query string as object and returns the result of applying f to it
adjustQuery = (f) -> f getQuery()

# :: {url, queryF} -> {k:v}
# returns a new url base on passed url or current url and queryF applied to current query
adjustUrl = ({url, queryF}) ->
	urlToUse = url || urlWithoutQuery()
	if queryF
		kvToQuery = ([k, v]) -> "#{k}=#{v}"
		newQuery = '?' + cc join('&'), map(kvToQuery), toPairs, queryF(getQuery())
	return urlToUse + (newQuery || '')

# :: s -> null   # Does a "modern" navigate using pushState and dispatchEvent
navigate = (url) ->
	# idea from https://github.com/larrymyers/react-mini-router/blob/master/lib/navigate.js
	window.history.pushState {}, '', url
	window.dispatchEvent new window.Event('popstate')
	return null # return null to work around warning, see navigateCallback

# :: o -> bool   # returns true if user clicked using left mouse
# stolen from https://github.com/rackt/react-router/blob/master/modules/Link.js
isLeftClickEvent = (e) -> e.button == 0

# :: o -> bool   # returns true if user clicked while modifier was pressed
isModifiedEvent = (e) -> !!(e.metaKey || e.altKey || e.ctrlKey || e.shiftKey)

# :: s -> f(e)
# given a url, returns a callback to use for onClick in a(href) elements in react
navigateCallback = (url) -> (e) ->
	# if a user clicks with the mouse-wheel or using e.g. cmd + click
	# we have to abord and let the browser open that link in a new tab / window
	if isModifiedEvent(e) || !isLeftClickEvent(e) then return e

	navigate url
	e.preventDefault()
	# if we return false or true we get error msg from react
	# 'Warning: Returning `false` from an event handler is deprecated'
	return e # ..so we're returning the event

module.exports = {getQuery, urlWithoutQuery, adjustQuery, adjustUrl, navigate, isLeftClickEvent, isModifiedEvent, navigateCallback}
