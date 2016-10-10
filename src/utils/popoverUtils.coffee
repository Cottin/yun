{into, merge, over, props, values} = require 'ramda' #auto_require:ramda

# Supported placements of the popover in relation to its anchor
exports.PLACEMENTS = PLACEMENTS = [
	'top-left', 'top-center', 'top-right',
	'left-bottom', 'left-center', 'left-top',
	'right-bottom', 'right-center', 'right-top',
	'bottom-left', 'bottom-center', 'bottom-right',
]

# Calculates the best position and maximum size of the popover given the
# current size of the viewport and current scroll.
# Takes one parameter (args) with props {popover, anchor, viewport, placement}.
# Returns an object with the following properties:
# top, bottom, left, right, maxHeight, maxWidth
exports.calcPosition = calcPosition = (args) ->
	{viewport} = args_ = toCoord args

	{top, bottom, maxHeight} = calcBestPositionY args_
	{left, right, maxWidth} = calcBestPositionX args_
	return fromCoord {viewport}, {top, bottom, maxHeight, left, right, maxWidth}

# Converts args into a coordinate system with its origin (0, 0) in the top left
# corner of the body. This is a helper to make it easier to do calculations.
toCoord = (args) ->
	{popover, anchor, viewport, placement} = args

	popover: popover

	anchor:
		top: anchor.top + viewport.scrollY
		bottom:  anchor.top + anchor.height + viewport.scrollY
		left: anchor.left + viewport.scrollX
		right: anchor.left + anchor.width + viewport.scrollX
		height: anchor.height
		width: anchor.width
		margin: anchor.margin
		middleX: anchor.left + (anchor.width / 2)
		middleY: anchor.top + (anchor.height / 2)

	# for viewport we assume the margins make the boundaries
	viewport: merge viewport,
		top: viewport.scrollY + viewport.margin
		bottom: viewport.scrollY + viewport.height - viewport.margin
		left: viewport.scrollX + viewport.margin
		right: viewport.scrollX + viewport.width - viewport.margin
		width: viewport.width - viewport.margin * 2
		height: viewport.height - viewport.margin * 2

	placement: placement

# The opposite of toCoord
fromCoord = ({viewport}, {top, bottom, maxHeight, left, right, maxWidth}) ->
	{top, left,
	# If we don't round these values the popover content might be a bit bigger
	# than the popover with like 1-2 pixels and it looks ugly
	maxHeight: Math.round(maxHeight),
	maxWidth: Math.round(maxWidth),
	bottom: if bottom then viewport.bodyHeight - bottom,
	right: if right then viewport.bodyWidth - right}

# Returns how much vertical overflow we'll have in the popover given a maxHeight.
overflowY = ({popover}, {maxHeight}) ->
	Math.max popover.scrollHeight - maxHeight, 0

# Calculates the "best" vertical position consisting of a {top} or {bottom} and a
# {maxHeight}.
calcBestPositionY = (args) ->
	primaryPosition = calcPrimaryPositionY args
	primaryOverflow = overflowY args, primaryPosition

	if primaryOverflow == 0 then return primaryPosition

	secondaryPosition = calcSecondaryPositionY args, primaryPosition
	secondaryOverflow = overflowY args, secondaryPosition

	if primaryOverflow < secondaryOverflow
		return primaryPosition

	return secondaryPosition

# Calculates the "primary" / "prefered" vertical position based on the prefered
# placement.
calcPrimaryPositionY = (args) ->
	{popover, anchor, viewport, placement} = args

	switch placement
		when 'top-left', 'top-center', 'top-right'
			bottom = anchor.top - anchor.margin
			availableSpace = bottom - viewport.top
			{bottom, maxHeight: availableSpace}
		when 'bottom-left', 'bottom-right', 'bottom-center'
			top = anchor.bottom + anchor.margin
			availableSpace = viewport.bottom - top
			{top, maxHeight: availableSpace}
		when 'left-top', 'right-top'
			availableSpace = anchor.bottom - viewport.top
			{bottom: anchor.bottom, maxHeight: availableSpace}
		when 'left-bottom', 'right-bottom'
			availableSpace = viewport.bottom - anchor.top
			{top: anchor.top, maxHeight: availableSpace}
		when 'left-center', 'right-center'
			if anchor.top < viewport.top
				calcPrimaryPositionY merge(args, {placement: 'left-bottom'})
			else if anchor.bottom > viewport.bottom
				calcPrimaryPositionY merge(args, {placement: 'left-top'})
			else
				top = anchor.top + anchor.height/2 - popover.scrollHeight/2
				if top < viewport.top
					top = viewport.top
				availableSpace = viewport.bottom - top
				{top, maxHeight: availableSpace}

# Calculates a "secondary" vertical position based on a prefered placement and
# a result from the primary calculation.
calcSecondaryPositionY = (args, primaryPosition) ->
	{popover, anchor, viewport, placement} = args

	switch placement
		when 'top-left', 'top-center', 'top-right'
			calcPrimaryPositionY merge(args, {placement: 'bottom-left'})
		when 'bottom-left', 'bottom-center', 'bottom-right'
			calcPrimaryPositionY merge(args, {placement: 'top-left'})
		when 'left-top', 'right-top'
			calcPrimaryPositionY merge(args, {placement: 'left-bottom'})
		when 'left-bottom', 'right-bottom'
			calcPrimaryPositionY merge(args, {placement: 'left-top'})
		when 'left-center', 'right-center'
			# we have already done our best in this case
			primaryPosition

# Returns how much horizontal overflow we'll have in the popover given a
# maxWidth.
overflowX = ({popover}, {maxWidth}) ->
	Math.max popover.scrollWidth - maxWidth, 0

# Calculates the "best" horizontal position consisting of a {left} and a
# {maxWidth}.
calcBestPositionX = (args) ->
	primaryPosition = calcPrimaryPositionX args
	primaryOverflow = overflowX args, primaryPosition

	if primaryOverflow == 0 then return primaryPosition

	secondaryPosition = calcSecondaryPositionX args, primaryPosition
	secondaryOverflow = overflowX args, secondaryPosition

	if primaryOverflow < secondaryOverflow
		return primaryPosition

	return secondaryPosition

# Calculates the "primary" / "prefered" horizontal position based on the
# prefered placement.
calcPrimaryPositionX = (args) ->
	{popover, anchor, viewport, placement} = args

	switch placement
		when 'top-right', 'bottom-right'
			left = anchor.left
			availableSpace = viewport.right - left
			{left, maxWidth: availableSpace}
		when 'top-left', 'bottom-left'
			right = anchor.right
			availableSpace = right - viewport.left
			{right, maxWidth: availableSpace}
		when 'top-center', 'bottom-center'
			left = anchor.middleX - (popover.width / 2)
			availableSpace = viewport.right - left
			{left, maxWidth: availableSpace}
		when 'left-top', 'left-bottom', 'left-center'
			left = anchor.left - popover.width - anchor.margin
			availableSpace = left + popover.width - viewport.left
			{left, maxWidth: availableSpace}
		when 'right-top', 'right-bottom', 'right-center'
			left = anchor.right + anchor.margin
			availableSpace = viewport.right - left
			{left, maxWidth: availableSpace}

# Calculates a "secondary" horizontal position based on a prefered placement and
# a result from the primary calculation.
calcSecondaryPositionX = (args, primaryPosition) ->
	{popover, anchor, viewport, placement} = args

	switch placement
		when 'top-right', 'bottom-right'
			calcPrimaryPositionX merge(args, {placement: 'top-left'})
		when 'top-left', 'bottom-left'
			calcPrimaryPositionX merge(args, {placement: 'top-right'})
		when 'top-center', 'bottom-center'
			if anchor.right > viewport.right
				calcPrimaryPositionX merge(args, {placement: 'top-left'})
			else if anchor.left < viewport.left
				calcPrimaryPositionX merge(args, {placement: 'top-right'})
			else
				pushRightIfNeeded(args, pushLeftIfNeeded(args, primaryPosition))
		when 'left-top', 'left-bottom', 'left-center'
			calcPrimaryPositionX merge(args, {placement: 'right-top'})
		when 'right-top', 'right-bottom', 'right-center'
			calcPrimaryPositionX merge(args, {placement: 'left-top'})

# Checks if the popover reaches over the right side of the viewport and if so
# pushes it to the left so that it is inside of the viewport.
pushLeftIfNeeded = (args, position) ->
	{popover, viewport, anchor} = args
	popoverRight = position.left + popover.width
	diff = popoverRight - viewport.right
	if diff <= 0 then position
	else
		newLeft = Math.max(position.left - diff, anchor.right - popover.width)
		newMaxWidth = viewport.right - newLeft
		merge position, {left: newLeft, maxWidth: newMaxWidth}

# Checks if the popover reaches over the left side of the viewport and if so
# pushes it to the right so that it is inside of the viewport.
pushRightIfNeeded = (args, position) ->
	{popover, viewport} = args
	popoverLeft = position.left
	diff = popoverLeft - viewport.left
	if diff >= 0 then position
	else merge position, {left: viewport.left, maxWidth: viewport.width}

