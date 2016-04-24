
# node, node -> bool
# Returns true if child is a descendant of parent, otherwise false
isDescendant = (parent, child) ->
	if !child then false
	if parent == child then true
	else isDescendant parent, child.parentNode

module.exports = {isDescendant}
