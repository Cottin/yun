{filter, gte, max, min} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'
lo = require 'lodash'

# Some commonly used ASCII key codes
keyCodes =
	ENTER: 13
	ESC: 27
	UP: 38
	DOWN: 40
	TAB: 9

# Predefined "interesting" screen sizes
screenSizes =
	XS: 0
	S: 550
	M: 850
	L: 1200
	XL: 1650
	
# :: [n] -> n
# Returns the biggest value from 'sizes' that is smaller than the current innerWidth
# e.g [0, 110, 221, 380, 100], width=289 returns 221, width=221 returns 221
closestWindowWidth = (sizes) -> cc max, filter(gte(window.innerWidth)), sizes
# TODO: should probably change the name to like closestAbove or closestMax or something!

# :: [n] -> [MediaQueryList]
# Returns an array of MediaQueryList with a min-with query for each size
# https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList
# https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Testing_media_queries
minWidthQueries = (sizes) -> sizes.map (size) -> window.matchMedia("(min-width: #{size}px)")

module.exports = {keyCodes, screenSizes, closestWindowWidth, minWidthQueries}
