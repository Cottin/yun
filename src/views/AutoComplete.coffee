React = require 'react'
Radium = require 'radium'
Style = React.createFactory Radium.Style
{nth, length, map, last, type, curry, has, compose, __, omit, keys, merge, mapObjIndexed, inc} = require 'ramda'
{cc, evolveAll, yforEach} = require 'ramda-extras'
{number, shape, arrayOf, element, any, func, string, object} = React.PropTypes
{functions: {callAll}, react: {evolveState}} = utils = require '../utils/utils'
PopupView = React.createFactory require './PopupView'
Modal = React.createFactory require './Modal'
Sidebar = React.createFactory require './Sidebar'

{div} = React.DOM

{defaultInputStyle, defaultPopupStyle, defaultSidebarStyle, defaultModalStyle} = require './AutoComplete.style'

{XS, S, M} = utils.browser.screenSizes
M_OR_MORE = M
windowSizes = [XS, S, M_OR_MORE]

ThereIsMoreMessage = React.createFactory React.createClass
	displayName: 'ThereIsMoreMessage'
	render: -> div {}, 'Showing first 50 matches'

AutoComplete = React.createClass
	displayName: 'AutoComplete'

	propTypes:
		items: arrayOf(any).isRequired
		selectedItem: any
		filterFn: func
		onPicked: func
		extractItemText: func
		input: shape
			component: element
			props: object
		popup: shape
			itemComponent: element
			props: object
			style: object
		sidebar: shape
			itemComponent: element
			props: object
			style: object
		modal: shape
			itemComponent: element
			props: object
			style: object
		optimize: shape
			renderOnlyTop: number
			thereIsMoreComponent: func

	getInitialState: ->
		isItemSelected: false
		indexOfFocusedItem: 0
		isOpen: false
		windowSize: utils.browser.closestWindowWidth windowSizes
		shouldFilter: false

	componentDidMount: ->
		@minWidthQueries = utils.browser.minWidthQueries windowSizes
		@minWidthQueries.forEach (x) => x.addListener @onWindowSizeChangedZone

	componentWillUnmount: ->
		@minWidthQueries.forEach (x) => x.removeListener @onWindowSizeChangedZone


	##### RENDER
	render: ->
		if @props.children then throw new Error 'AutoComplete cant have children'

		div {},
			if @state.windowSize == M_OR_MORE
				div {},
					@renderInput()
					if @state.isOpen then @renderPopup()
			else if @state.windowSize == S
				div {},
					@renderInput()
					if @state.isOpen
						div {},
							Style {rules:{body:{overflow:'hidden'}}}
							@renderSidebar()
			else if @state.windowSize == XS
				div {},
					@renderInput()
					if @state.isOpen
						div {},
							Style {rules:{body:{overflow:'hidden'}}}
							@renderModal()

	renderInput: ->
		{component, props} = @props.input
		propsToRender = merge {style: defaultInputStyle, ref: 'input'}, props
		spec =
			style: (x) -> merge defaultInputStyle, x
			ref: always 'input'
			onFocus: (x) => callAll @onFocus, (x || F)
			onBlur: (x) => callAll @onBlur, (x || F)
			onKeyDown: (x) => callAll @onKeyDown, (x || F)
			onChange: (x) => callAll @onChange, (x || F)
		propsToRender = evolveAll spec, propsToRender

		return component propsToRender

	renderItem: ({component, props}) -> (item, index) =>
		{indexOfFocusedItem} = @state
		isSelected = index == indexOfFocusedItem
		key = ref = "item_#{index}"
		onMouseOver = => @setState {indexOfFocusedItem: index}
		onMouseDown = => @pick index
		extractItemText = @props.extractItemText
		propsToUse = merge props, {item, index, indexOfFocusedItem,
			isSelected, extractItemText}
		div {ref, key, tabIndex:-1, onMouseOver, onMouseDown},
			component propsToUse

	renderPopup: ->
		{itemComponent, props} = @props.popup
		component = React.createFactory itemComponent
		style = merge defaultPopupStyle, @props.popup.style
		PopupView {style}, @getFilteredItemsToRender({component, props})

	renderSidebar: ->
		{itemComponent, props} = @props.sidebar
		component = React.createFactory itemComponent
		style = merge defaultSidebarStyle, @props.sidebar.style
		Sidebar {style}, @getFilteredItemsToRender({component, props})

	renderModal: ->
		{itemComponent, props} = @props.modal
		component = React.createFactory itemComponent
		style = merge defaultModalStyle, @props.popup.style
		Modal {style}, @getFilteredItemsToRender({component, props})

	##### HELPERS
	getFilteredItems: ->
		{input, items, filterFn} = @props
		if @state.shouldFilter then filter filterFn, items
		else items

	getFilteredItemsToRender: ({component, props}) ->
		filteredItems = @getFilteredItems()
		renderOnlyTop = @props.optimize.renderOnlyTop || Infinity
		thereIsMoreComponent = @props.optimize.thereIsMoreComponent || ThereIsMoreMessage
		cappedItems =  slice 0, renderOnlyTop, filteredItems

		itemsToRender = mapIndexed @renderItem({component, props}), cappedItems
		if renderOnlyTop < length(filteredItems)
			itemsToRender.push thereIsMoreComponent()

		return itemsToRender

	close: -> @setState {isOpen: false, shouldFilter: false}
	open: -> if ! @state.isOpen then @setState {isOpen: true, isItemSelected: false}, @focusSelectedAtFirstOpen
	pick: (index) ->
		console.log 'pick!'
		{onPicked} = @props
		item = cc nth(index), @getFilteredItems()
		onPicked?({item})
		@setState {isItemSelected: true, indexOfFocusedItem: 0}
		@close()
	focusSelected: ->
		@refs["item_#{@state.indexOfFocusedItem}"].getDOMNode().focus()
		@refs.input.getDOMNode().focus()
	focusSelectedAtFirstOpen: ->
		{selectedItem} = @props
		indexOfFocusedItem = findIndex whereEq(selectedItem), @getFilteredItems() 
		@setState {indexOfFocusedItem}
		@refs["item_#{indexOfFocusedItem}"].getDOMNode().focus()
		@refs.input.getDOMNode().focus()


	##### HANDLERS
	onWindowSizeChangedZone: -> @setState {windowSize: utils.browser.closestWindowWidth(windowSizes)}
	onFocus: -> @open()

	onKeyDown: (e) ->
		{ENTER, ESC, UP, DOWN, TAB} = utils.browser.keyCodes
		{items, onPicked} = @props

		evolveindexOfFocusedItem = (f) =>
			e.preventDefault()
			if @state.isOpen then evolveState @, {indexOfFocusedItem:f}, @focusSelected
			else @open()

		switch e.keyCode
			when ENTER
				# without this check, pressing enter twice always selects the top of the list
				if !@state.isItemSelected then @pick @state.indexOfFocusedItem
			when ESC then @close()
			when UP then evolveindexOfFocusedItem (i) -> Math.max dec(i), 0
			when DOWN then evolveindexOfFocusedItem (i) -> Math.min inc(i), length(items)-1
			when TAB then @setState {isItemSelected: true}

	onBlur: (e) ->
		# in order to not have to mess with scroll height of popup you can hook
		# into the onUpDown cb and you get 10 ms to focus on the selected item
		# therefore we need to kind of "debounce-check" the onBlur event
		theInputElement = e.target
		continueIfStillNotFocuesd = =>
			theCurrentlyFocusedElement = document.activeElement 
			if theInputElement != theCurrentlyFocusedElement
				if !@state.isItemSelected then @props.onPicked?({item:null})
				@close()

		window.setTimeout continueIfStillNotFocuesd, 10

	onChange: ->
		@setState {isItemSelected: false, indexOfFocusedItem: 0, isOpen: true, shouldFilter:true}

module.exports = Radium AutoComplete
