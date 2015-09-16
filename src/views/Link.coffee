React = require 'react'
{assoc, dissoc, evolve, has, ifElse, keys, mapObj, merge, omit, whereEq} = require 'ramda' #auto_require:ramda
{a} = React.DOM
{adjustUrl, navigateCallback} = require '../utils/url'

Link = React.createClass
	displayName: 'Link'

	propTypes:
		url: React.PropTypes.string
		queryF: React.PropTypes.func

	render: ->
		href = adjustUrl @props
		linkProps = {href, onClick: navigateCallback(href)}
		otherProps = omit ['url', 'queryF'], @props
		a merge(linkProps, otherProps)

module.exports = Link

# like https://github.com/rackt/react-router/blob/master/docs/api/RouterContext.md#makehrefroutename-params-query
# but accepts a 'route-object' with keys pathName, params and query
# makeHref = ({pathName, params, query}, router) -> router.makeHref pathName, params, query

# returns a "route-object" with pathName, params and query
# getRouteData = (router) ->
# 	return {pathName: router.getCurrentPathname(), params: router.getCurrentParams(), query: router.getCurrentQuery()}

# returns an href with the current pathName and params but with a merge of the current query and first argument
# makeMergedQueryHref = (query, router) ->
# 	routeData = getRouteData router
# 	transformedQuery = merge routeData.query, query
# 	return makeHref merge(routeData, {query:transformedQuery}), router

# returns an href after passing the current 'route-object' through `evolve` with `transforms` as first argument
# makeEvolvedHref = (transforms, router) ->
# 	routeData = getRouteData router
# 	return makeHref evolve(transforms, routeData), router

# if key exists in current query, returns href without it, if not an href with the key=activeValue
# makeToggledQueryHref = (key, activeValue, router) ->
# 	addOrRemove = ifElse has(key), dissoc(key), assoc(key, activeValue)
# 	return makeEvolvedHref {query: addOrRemove}, router

# checks whether `query` is part of the current query (and therefor active)
# isQueryActive = (query, router) ->
# 	queryStringified = mapObj toStr, query
# 	return whereEq queryStringified, router.getCurrentQuery()
