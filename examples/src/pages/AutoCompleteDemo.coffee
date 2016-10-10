{PropTypes} = React = require 'react'
ReactDOM = require 'react-dom'
PureRenderMixin = require 'react-addons-pure-render-mixin'
Radium = require 'radium'
EventListener = require 'fbjs/lib/EventListener'
{div, h2, p, br, input} = React.DOM
# Popover = React.createFactory require '../views/Popover'
Popover = React.createFactory require 'yun-ui-kit/Popover'
EventListener = React.createFactory require 'yun-ui-kit/helpers/EventListener'
browserUtils = require 'yun-ui-kit/utils/browserUtils'
domUtils = require 'yun-ui-kit/utils/domUtils'
AutoComplete = require 'yun-ui-kit/AutoComplete'
AutoCompleteClient = require 'yun-ui-kit/AutoCompleteClient'
{evolveState, mergeState, build: _} = reactUtils = require 'yun-ui-kit/utils/reactUtils'
{__, always, dec, filter, inc, isNil, length, merge, props, set, take, test, type, without} = R = require 'ramda' #auto_require:ramda
{cc, mergeOrEvolve, ymap} = require 'ramda-extras'

# What to support?
# - Flexible lists (with groups etc.)
# - 

Item = React.createClass
	displayName: 'Item'

	# mixins: [PureRenderMixin]

	propTypes:
		text: PropTypes.string

	focus: ->
		ReactDOM.findDOMNode(this).focus()

	render: ->

		{text, isSelected} = @props
		if isSelected
			style = {background: 'lightblue', cursor: 'pointer'}
		else
			style = {cursor: 'pointer'}
		props_ = merge @props, {style}
		# in order for the browser to scroll to the element being .focus()-ed
		# we need to set tabIndex
		div props_, @props.text

Item_ = React.createFactory Item


module.exports = React.createClass
	displayName: 'AutoCompleteDemo'

	getInitialState: ->


		anchorEl: null
		isOpen: false
		selectedIndex: null

		# simple:
		# 	filteredItems: take 45, pokemons
		# 	text: ''
		# 	isOpen: false

		simpleFilteredItems: take 45, pokemons
		simpleText: ''
		simpleIsOpen: false
		simpleAnchorEl: null
		simpleSelectedIndex: null

		simpleAutoCompleteText: ''
		items: take 45, pokemons

		clientItems: take 45, pokemons
		clientItemPicked: null

		clientDefaultItems: take 45, pokemons
		clientDefaultItemPicked: null

		itemsFromServer: []

		openId: null


	# popover on big screens modal on smaller (part of popup component?)
	#		or maybe put that in other component?
	# filter
	# up/down arrow and scrolling to focus

	render: ->
		div {},
			h2 {}, 'AutoComplete'
			br()
			p {}, 'Simple'
			_ AutoComplete,
				items: @state.simpleFilteredItems
				renderItem: (props, item) ->
					_ Item, merge(props, {text: item})
				renderInput: (defaultProps) =>
					input merge(defaultProps, {
						value: @state.simpleText
						onChange: @onSimpleInputChange
					})
				renderEmpty: -> div {}, 'No pokemons matches'
				onPicked: @filterSimpleItems
				text: @state.simpleText
				canPickWithTab: true
				onRequestOpen: (e) =>
					@setState {simpleIsOpen: true, simpleAnchorEl: e.currentTarget}
				onRequestClose: =>
					@setState {simpleIsOpen: false, simpleAnchorEl: null}
				selectedIndex: @state.simpleSelectedIndex
				onRequestSelectedIndexChange: (newIndex) =>
					@setState {simpleSelectedIndex: newIndex}
				popover:
					props:
						placement: 'bottom-right'
						anchorEl: @state.simpleAnchorEl
						isOpen: @state.simpleIsOpen
					style: {width: 200, padding: 10}

			br()
			p {}, 'Client search:'
			_ AutoCompleteClient,
				items: @state.clientItems
				filter: (text, item) -> test new RegExp("^#{text}", 'i'), item
				renderItem: (props, item) -> _ Item, merge(props, {text: item})
				renderInput: (defaultProps) -> input defaultProps
				renderEmpty: -> div {}, 'No pokemons matches'
				onPicked: (item) => @setState {clientItemPicked: item}
				canPickWithTab: true
				popover:
					props:
						placement: 'bottom-right'
					style: {width: 200, padding: 10}

			# _ AutoCompleteClient, {},
			# 	({Item, Input}) ->
			# 		Item {},
			# 			ListItem {}
			# 		Input {}

			div {}, 'Picked item: ' + @state.clientItemPicked

			br()
			p {}, 'Client search (making use of defaults):'
			_ AutoCompleteClient,
				items: @state.clientDefaultItems
				onPicked: (item) => @setState {clientDefaultItemPicked: item}
			div {}, 'Picked item: ' + @state.clientDefaultItemPicked


			# p {}, 'Server search:'
			# br()
			# _ AutoComplete,
			# 	items: @state.itemsFromServer
			# 	renderItem: (props, item) ->
			# 		_ Item, merge(props, {text: item})
			# 	filterItems: (text, items) => items # no filter for server-side search
			# 	onPicked: (item) => @setState {serverSideAutoCompleteText: item}
			# 	text: @state.serverSideAutoCompleteText
			# 	onInputChange: (e) =>
			# 		@fakeServerFetch e.currentTarget.value
			# 		@setState {serverSideAutoCompleteText: e.currentTarget.value}


			br()
			br()
			br()
			br()
			p {}, 'Customized list with groups: TODO'

	onSimpleInputChange: (e) ->
		@filterSimpleItems e.currentTarget.value
		if !@state.simpleIsOpen
			@setState {simpleIsOpen: true, simpleAnchorEl: e.currentTarget}
		@setState {simpleSelectedIndex: 0}
		
	filterSimpleItems: (text) ->
		re = new RegExp "^#{text}", 'i'
		filteredItems = filter test(re), @state.items
		# mergeState @, {simple: {filteredItems, text}}
		@setState
			simpleFilteredItems: filteredItems
			simpleText: text
		# evolveState @, {simple: merge(__, {filteredItems, text})}
		# TODO, this api:
		# setStateAt @, 'simple', {filteredItems}

	fakeServerFetch: (text) ->
		re = new RegExp "^#{text}", 'i'
		filteredItems = filter test(re), @state.items
		setItems = () =>
			@setState {itemsFromServer: filteredItems}
		window.setTimeout setItems, 1000
			# AutoComplete
			# 	filter: (text) -> pokemons
			# 	renderInput: ->
			# 		input {type: text}
			# 	renderList: (items) ->
			# 		ul {},
			# 			ymap items, (x) ->
			# 				li {}, x
			# if small screen
			# FilterDialog
	# 		p {}, 'Custom with groups'
	# 		input
	# 			ref: 'input'
	# 			onFocus: @onFocus
	# 			onBlur: @onBlur
	# 			onKeyDown: @onKeyDown
	# 			onChange: @onChange
	# 		Popover
	# 			isOpen: @state.openId == 1
	# 			anchorEl: @state.anchorEl
	# 		,
	# 			div {style: {maxHeight: 'inherit', overflow: 'scroll'}},
	# 				ymapIndexed @state.items, (item, i) =>
	# 					Item_ {key: item, ref: "item_#{i}", text: item, isSelected: i == @state.index}
	# 		EventListener 
	# 			element: window
	# 			onWheel: (e) =>
	# 				# Research around this concludes you cannot cancel the scroll event
	# 				# but you can cancel the events provoking the scroll event
	# 				# http://stackoverflow.com/questions/4770025/how-to-disable-scrolling-temporarily
	# 				# http://stackoverflow.com/questions/8813051/determine-which-element-the-mouse-pointer-is-on-top-of-in-javascript

	# 				hoveredElement = document.elementFromPoint(e.clientX, e.clientY)
	# 				console.log 'hoveredElement', hoveredElement
	# 				if isNil hoveredElement then return
	# 				if domUtils.isDescendant(hoveredElement, ReactDOM.findDOMNode(this))
	# 					console.log('isDescendent')
	# 					e.preventDefault()

	# 		p {}, 'Custom with server-side fetching'

	# 		br()
	# 		br()
	# 		br()
	# 		br()
	# 		br()
	# 		br()
	# 		br()
	# 		br()
	# 		br()
	# 		br()
	# 		br()
	# 		br()

	# onFocus: (e) ->
	# 	@setState {anchorEl: e.currentTarget, openId: 1, index: 0}

	# onBlur: ->
	# 	@setState {anchorEl: null, openId: null}

	# onKeyDown: (e) ->
	# 	{ENTER, ESC, UP, DOWN, TAB} = browserUtils.keyCodes
	# 	{items, index} = @state
		
	# 	switch e.keyCode
	# 		when ENTER
	# 			# without this check, pressing enter twice always selects the top of the list
	# 			if !@state.isItemSelected then @pick @state.indexOfFocusedItem
	# 		when ESC then @close()
	# 		when UP
	# 			newIndex = Math.max dec(index), 0
	# 			@refs["item_#{newIndex}"]?.focus?()
	# 			@refs.input.focus()
	# 			# up arrow by default moves cursor in input to start, so we prevent it
	# 			e.preventDefault()
	# 			@setState {index: newIndex}
	# 		when DOWN
	# 			newIndex = Math.min inc(index), length(items)-1
	# 			@refs["item_#{newIndex}"]?.focus?()
	# 			@refs.input.focus()
	# 			# down arrow by default moves cursor in input to end, so we prevent it
	# 			e.preventDefault()
	# 			@setState {index: newIndex}
	# 		when TAB then @setState {isItemSelected: true}

	# onChange: (e) ->
	# 	re = new RegExp "^#{e.currentTarget.value}", 'i'
	# 	@setState {items: filter(test(re), pokemons)}



pokemons = [
	'Abomasnow',
	'Abra',
	'Absol',
	'Accelgor',
	'Aegislash',
	'Aerodactyl',
	'Aggron',
	'Aipom',
	'Alakazam',
	'Alomomola',
	'Altaria',
	'Amaura',
	'Ambipom',
	'Amoonguss',
	'Ampharos',
	'Anorith',
	'Arbok',
	'Arcanine',
	'Arceus',
	'Archen',
	'Archeops',
	'Ariados',
	'Armaldo',
	'Aromatisse',
	'Aron',
	'Articuno',
	'Audino',
	'Aurorus',
	'Avalugg',
	'Axew',
	'Azelf',
	'Azumarill',
	'Azurill',
	'Bagon',
	'Baltoy',
	'Banette',
	'Barbaracle',
	'Barboach',
	'Basculin',
	'Bastiodon',
	'Bayleef',
	'Beartic',
	'Beautifly',
	'Beedrill',
	'Beheeyem',
	'Beldum',
	'Bellossom',
	'Bellsprout',
	'Bergmite',
	'Bibarel',
	'Bidoof',
	'Binacle',
	'Bisharp',
	'Blastoise',
	'Blaziken',
	'Blissey',
	'Blitzle',
	'Boldore',
	'Bonsly',
	'Bouffalant',
	'Braixen',
	'Braviary',
	'Breloom',
	'Bronzong',
	'Bronzor',
	'Budew',
	'Buizel',
	'Bulbasaur',
	'Buneary',
	'Bunnelby',
	'Burmy',
	'Butterfree',
	'Cacnea',
	'Cacturne',
	'Camerupt',
	'Carbink',
	'Carnivine',
	'Carracosta',
	'Carvanha',
	'Cascoon',
	'Castform',
	'Caterpie',
	'Celebi',
	'Chandelure',
	'Chansey',
	'Charizard',
	'Charmander',
	'Charmeleon',
	'Chatot',
	'Cherrim',
	'Cherubi',
	'Chesnaught',
	'Chespin',
	'Chikorita',
	'Chimchar',
	'Chimecho',
	'Chinchou',
	'Chingling',
	'Cinccino',
	'Clamperl',
	'Clauncher',
	'Clawitzer',
	'Claydol',
	'Clefable',
	'Clefairy',
	'Cleffa',
	'Cloyster',
	'Cobalion',
	'Cofagrigus',
	'Combee',
	'Combusken',
	'Conkeldurr',
	'Corphish',
	'Corsola',
	'Cottonee',
	'Cradily',
	'Cranidos',
	'Crawdaunt',
	'Cresselia',
	'Croagunk',
	'Crobat',
	'Croconaw',
	'Crustle',
	'Cryogonal',
	'Cubchoo',
	'Cubone',
	'Cyndaquil',
	'Darkrai',
	'Darmanitan',
	'Darumaka',
	'Dedenne',
	'Deerling',
	'Deino',
	'Delcatty',
	'Delibird',
	'Delphox',
	'Deoxys',
	'Dewgong',
	'Dewott',
	'Dialga',
	'Diancie',
	'Diggersby',
	'Diglett',
	'Ditto',
	'Dodrio',
	'Doduo',
	'Donphan',
	'Doublade',
	'Dragalge',
	'Dragonair',
	'Dragonite',
	'Drapion',
	'Dratini',
	'Drifblim',
	'Drifloon',
	'Drilbur',
	'Drowzee',
	'Druddigon',
	'Ducklett',
	'Dugtrio',
	'Dunsparce',
	'Duosion',
	'Durant',
	'Dusclops',
	'Dusknoir',
	'Duskull',
	'Dustox',
	'Dwebble',
	'Eelektrik',
	'Eelektross',
	'Eevee',
	'Ekans',
	'Electabuzz',
	'Electivire',
	'Electrike',
	'Electrode',
	'Elekid',
	'Elgyem',
	'Emboar',
	'Emolga',
	'Empoleon',
	'Entei',
	'Escavalier',
	'Espeon',
	'Espurr',
	'Excadrill',
	'Exeggcute',
	'Exeggutor',
	'Exploud',
	'Farfetchd',
	'Fearow',
	'Feebas',
	'Fennekin',
	'Feraligatr',
	'Ferroseed',
	'Ferrothorn',
	'Finneon',
	'Flaaffy',
	'Flabébé',
	'Flareon',
	'Fletchinder',
	'Fletchling',
	'Floatzel',
	'Floette',
	'Florges',
	'Flygon',
	'Foongus',
	'Forretress',
	'Fraxure',
	'Frillish',
	'Froakie',
	'Frogadier',
	'Froslass',
	'Furfrou',
	'Furret',
	'Gabite',
	'Gallade',
	'Galvantula',
	'Garbodor',
	'Garchomp',
	'Gardevoir',
	'Gastly',
	'Gastrodon',
	'Genesect',
	'Gengar',
	'Geodude',
	'Gible',
	'Gigalith',
	'Girafarig',
	'Giratina',
	'Glaceon',
	'Glalie',
	'Glameow',
	'Gligar',
	'Gliscor',
	'Gloom',
	'Gogoat',
	'Golbat',
	'Goldeen',
	'Golduck',
	'Golem',
	'Golett',
	'Golurk',
	'Goodra',
	'Goomy',
	'Gorebyss',
	'Gothita',
	'Gothitelle',
	'Gothorita',
	'Gourgeist',
	'Granbull',
	'Graveler',
	'Greninja',
	'Grimer',
	'Grotle',
	'Groudon',
	'Grovyle',
	'Growlithe',
	'Grumpig',
	'Gulpin',
	'Gurdurr',
	'Gyarados',
	'Happiny',
	'Hariyama',
	'Haunter',
	'Hawlucha',
	'Haxorus',
	'Heatmor',
	'Heatran',
	'Heliolisk',
	'Helioptile',
	'Heracross',
	'Herdier',
	'Hippopotas',
	'Hippowdon',
	'Hitmonchan',
	'Hitmonlee',
	'Hitmontop',
	'Ho-Oh',
	'Honchkrow',
	'Honedge',
	'Hoopa',
	'Hoothoot',
	'Hoppip',
	'Horsea',
	'Houndoom',
	'Houndour',
	'Huntail',
	'Hydreigon',
	'Hypno',
	'Igglybuff',
	'Illumise',
	'Infernape',
	'Inkay',
	'Ivysaur',
	'Jellicent',
	'Jigglypuff',
	'Jirachi',
	'Jolteon',
	'Joltik',
	'Jumpluff',
	'Jynx',
	'Kabuto',
	'Kabutops',
	'Kadabra',
	'Kakuna',
	'Kangaskhan',
	'Karrablast',
	'Kecleon',
	'Keldeo',
	'Kingdra',
	'Kingler',
	'Kirlia',
	'Klang',
	'Klefki',
	'Klink',
	'Klinklang',
	'Koffing',
	'Krabby',
	'Kricketot',
	'Kricketune',
	'Krokorok',
	'Krookodile',
	'Kyogre',
	'Kyurem',
	'Lairon',
	'Lampent',
	'Landorus',
	'Lanturn',
	'Lapras',
	'Larvesta',
	'Larvitar',
	'Latias',
	'Latios',
	'Leafeon',
	'Leavanny',
	'Ledian',
	'Ledyba',
	'Lickilicky',
	'Lickitung',
	'Liepard',
	'Lileep',
	'Lilligant',
	'Lillipup',
	'Linoone',
	'Litleo',
	'Litwick',
	'Lombre',
	'Lopunny',
	'Lotad',
	'Loudred',
	'Lucario',
	'Ludicolo',
	'Lugia',
	'Lumineon',
	'Lunatone',
	'Luvdisc',
	'Luxio',
	'Luxray',
	'Machamp',
	'Machoke',
	'Machop',
	'Magby',
	'Magcargo',
	'Magikarp',
	'Magmar',
	'Magmortar',
	'Magnemite',
	'Magneton',
	'Magnezone',
	'Makuhita',
	'Malamar',
	'Mamoswine',
	'Manaphy',
	'Mandibuzz',
	'Manectric',
	'Mankey',
	'Mantine',
	'Mantyke',
	'Maractus',
	'Mareep',
	'Marill',
	'Marowak',
	'Marshtomp',
	'Masquerain',
	'Mawile',
	'Medicham',
	'Meditite',
	'Meganium',
	'Meloetta',
	'Meowstic',
	'Meowth',
	'Mesprit',
	'Metagross',
	'Metang',
	'Metapod',
	'Mew',
	'Mewtwo',
	'Mienfoo',
	'Mienshao',
	'Mightyena',
	'Milotic',
	'Miltank',
	'Mime Jr.',
	'Minccino',
	'Minun',
	'Misdreavus',
	'Mismagius',
	'Moltres',
	'Monferno',
	'Mothim',
	'Mr. Mime',
	'Mudkip',
	'Muk',
	'Munchlax',
	'Munna',
	'Murkrow',
	'Musharna',
	'Natu',
	'Nidoking',
	'Nidoqueen',
	'Nidoran♀',
	'Nidoran♂',
	'Nidorina',
	'Nidorino',
	'Nincada',
	'Ninetales',
	'Ninjask',
	'Noctowl',
	'Noibat',
	'Noivern',
	'Nosepass',
	'Numel',
	'Nuzleaf',
	'Octillery',
	'Oddish',
	'Omanyte',
	'Omastar',
	'Onix',
	'Oshawott',
	'Pachirisu',
	'Palkia',
	'Palpitoad',
	'Pancham',
	'Pangoro',
	'Panpour',
	'Pansage',
	'Pansear',
	'Paras',
	'Parasect',
	'Patrat',
	'Pawniard',
	'Pelipper',
	'Persian',
	'Petilil',
	'Phanpy',
	'Phantump',
	'Phione',
	'Pichu',
	'Pidgeot',
	'Pidgeotto',
	'Pidgey',
	'Pidove',
	'Pignite',
	'Pikachu',
	'Piloswine',
	'Pineco',
	'Pinsir',
	'Piplup',
	'Plusle',
	'Politoed',
	'Poliwag',
	'Poliwhirl',
	'Poliwrath',
	'Ponyta',
	'Poochyena',
	'Porygon',
	'Porygon-Z',
	'Porygon2',
	'Primeape',
	'Prinplup',
	'Probopass',
	'Psyduck',
	'Pumpkaboo',
	'Pupitar',
	'Purrloin',
	'Purugly',
	'Pyroar',
	'Quagsire',
	'Quilava',
	'Quilladin',
	'Qwilfish',
	'Raichu',
	'Raikou',
	'Ralts',
	'Rampardos',
	'Rapidash',
	'Raticate',
	'Rattata',
	'Rayquaza',
	'Regice',
	'Regigigas',
	'Regirock',
	'Registeel',
	'Relicanth',
	'Remoraid',
	'Reshiram',
	'Reuniclus',
	'Rhydon',
	'Rhyhorn',
	'Rhyperior',
	'Riolu',
	'Roggenrola',
	'Roselia',
	'Roserade',
	'Rotom',
	'Rufflet',
	'Sableye',
	'Salamence',
	'Samurott',
	'Sandile',
	'Sandshrew',
	'Sandslash',
	'Sawk',
	'Sawsbuck',
	'Scatterbug',
	'Sceptile',
	'Scizor',
	'Scolipede',
	'Scrafty',
	'Scraggy',
	'Scyther',
	'Seadra',
	'Seaking',
	'Sealeo',
	'Seedot',
	'Seel',
	'Seismitoad',
	'Sentret',
	'Serperior',
	'Servine',
	'Seviper',
	'Sewaddle',
	'Sharpedo',
	'Shaymin',
	'Shedinja',
	'Shelgon',
	'Shellder',
	'Shellos',
	'Shelmet',
	'Shieldon',
	'Shiftry',
	'Shinx',
	'Shroomish',
	'Shuckle',
	'Shuppet',
	'Sigilyph',
	'Silcoon',
	'Simipour',
	'Simisage',
	'Simisear',
	'Skarmory',
	'Skiddo',
	'Skiploom',
	'Skitty',
	'Skorupi',
	'Skrelp',
	'Skuntank',
	'Slaking',
	'Slakoth',
	'Sliggoo',
	'Slowbro',
	'Slowking',
	'Slowpoke',
	'Slugma',
	'Slurpuff',
	'Smeargle',
	'Smoochum',
	'Sneasel',
	'Snivy',
	'Snorlax',
	'Snorunt',
	'Snover',
	'Snubbull',
	'Solosis',
	'Solrock',
	'Spearow',
	'Spewpa',
	'Spheal',
	'Spinarak',
	'Spinda',
	'Spiritomb',
	'Spoink',
	'Spritzee',
	'Squirtle',
	'Stantler',
	'Staraptor',
	'Staravia',
	'Starly',
	'Starmie',
	'Staryu',
	'Steelix',
	'Stoutland',
	'Stunfisk',
	'Stunky',
	'Sudowoodo',
	'Suicune',
	'Sunflora',
	'Sunkern',
	'Surskit',
	'Swablu',
	'Swadloon',
	'Swalot',
	'Swampert',
	'Swanna',
	'Swellow',
	'Swinub',
	'Swirlix',
	'Swoobat',
	'Sylveon',
	'Taillow',
	'Talonflame',
	'Tangela',
	'Tangrowth',
	'Tauros',
	'Teddiursa',
	'Tentacool',
	'Tentacruel',
	'Tepig',
	'Terrakion',
	'Throh',
	'Thundurus',
	'Timburr',
	'Tirtouga',
	'Togekiss',
	'Togepi',
	'Togetic',
	'Torchic',
	'Torkoal',
	'Tornadus',
	'Torterra',
	'Totodile',
	'Toxicroak',
	'Tranquill',
	'Trapinch',
	'Treecko',
	'Trevenant',
	'Tropius',
	'Trubbish',
	'Turtwig',
	'Tympole',
	'Tynamo',
	'Typhlosion',
	'Tyranitar',
	'Tyrantrum',
	'Tyrogue',
	'Tyrunt',
	'Umbreon',
	'Unfezant',
	'Unown',
	'Ursaring',
	'Uxie',
	'Vanillish',
	'Vanillite',
	'Vanilluxe',
	'Vaporeon',
	'Venipede',
	'Venomoth',
	'Venonat',
	'Venusaur',
	'Vespiquen',
	'Vibrava',
	'Victini',
	'Victreebel',
	'Vigoroth',
	'Vileplume',
	'Virizion',
	'Vivillon',
	'Volbeat',
	'Volcanion',
	'Volcarona',
	'Voltorb',
	'Vullaby',
	'Vulpix',
	'Wailmer',
	'Wailord',
	'Walrein',
	'Wartortle',
	'Watchog',
	'Weavile',
	'Weedle',
	'Weepinbell',
	'Weezing',
	'Whimsicott',
	'Whirlipede',
	'Whiscash',
	'Whismur',
	'Wigglytuff',
	'Wingull',
	'Wobbuffet',
	'Woobat',
	'Wooper',
	'Wormadam',
	'Wurmple',
	'Wynaut',
	'Xatu',
	'Xerneas',
	'Yamask',
	'Yanma',
	'Yanmega',
	'Yveltal',
	'Zangoose',
	'Zapdos',
	'Zebstrika',
	'Zekrom',
	'Zigzagoon',
	'Zoroark',
	'Zorua',
	'Zubat',
	'Zweilous',
	'Zygarde' 
]

