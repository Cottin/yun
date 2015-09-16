		{popupList} = @props
		{style, listItem} = popupList
		popupList {style: merge(defaultPopupStyle, )}

		countryInput = input 
			value: propOr autoCompleteText, 'name', selectedCountry
			placeholder: 'Country'
			onChange: (e) =>
				@setState {autoCompleteText: e.target.value, selectedCountry: null}

		popupListItem = Component ({item}) ->
			div {style, key:item.name},
				span {}, first
				span {style: {fontWeight: 'bold'}}, middle
				span {}, last


		# Normal compositional way
		style = {}
		Popup =
			render: ->
				div {style}, @props.children

		PopupList =
			propTypes:
				items: arrayOf component

			render: ->
				Popup {}, items

		AutoComplete = 
			propTypes:
				input: shape
					value.isRequired

			render: ->	
				{onChange, onFocus, onBlur, onKeyDown} = @input
				defaultInput = merge @input, {ref:'input'}
				build.merge defaultInput, @input



		# crazy compositional way
		style = {}
		Popup = compo
			render: ->
				div {style}, children

		Sidebar = compo
			render: ->
				Popup


		PopupList = compo ({children}) ->
			compose:
				Popup {style}, children

		defaultInput = {}
		AutoComplete = compo ({input}) ->
			compose:
				Div {},
					merge defaultInput, input






		yevolve AutoComplete,
			input: evolve 
				value: propOr autoCompleteText, 'name', selectedCountry
				placeholder: 'Country'
				onChange: (e) =>
					@setState {autoCompleteText: e.target.value, selectedCountry: null}
					
		popupList = PopupList
			items: popupListItem

		AutoComplete
			data: filteredCountries
			onPicked: ({item}) =>
				@setState
					selectedCountry: item
					autoCompleteText: propOr '', 'name', item
			input: countryInput
			popupList: popupList

			modal:
				renderItem: @_renderCountryModal
			sidebar:
				renderItem: @_renderCountrySidebar

		yevolve popupList,
			style: merge defaultPopupStyle
			listItem: evolve
				onMouseOver: utils.call2 
