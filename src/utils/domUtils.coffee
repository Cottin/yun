{either, isNil, map, set, sum} = require 'ramda' #auto_require:ramda

# node, node -> bool
# Returns true if child is a descendent of parent, otherwise false
exports.isDescendant = isDescendant = (parent, child) ->
	if !child then false
	else if parent == child then true
	else isDescendant parent, child.parentNode

# Walks children of node recursively and sums up thier scrollHeights to a total.
# Usage: when a node itself does not have overflow: scroll set, but its children
# have it, calling .scrollHeight of node results in 0. Instead we must sum it up
# from its descendants.
exports.getTotalScrollHeight = getTotalScrollHeight = (node) ->
	{children} = node
	if isNil(children) || children.length == 0
		return node.scrollHeight

	# Optimization! A node with more than 20 children is assumed to either
	#   * have 'overflow-y: scroll' set OR
	#		* not have children with 'overflow-y: scroll' set
	if children.length > 15 then return node.scrollHeight


	childrenScrollHeight = sum map(getTotalScrollHeight, children)

	# Max of node.scrollHeight (including padding etc.) or sum of children
	return Math.max node.scrollHeight, childrenScrollHeight

# Calls node.getBoundingClientRect but does not return the resulting ClientRect
# object but instead extracts the properties and returns them in an object
# literal. Motivation: R.merge(ClientRect, {}) returns {} 
exports.getBoundingClientRectAsObj  = getBoundingClientRectAsObj = (node) ->
	{top, right, bottom, left, width, height} = node.getBoundingClientRect()
	return {top, right, bottom, left, width, height}

