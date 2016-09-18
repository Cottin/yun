React = require 'react'
Radium = require 'radium'
EventListener = require 'fbjs/lib/EventListener'
{div, h2, p, br, input} = React.DOM
domUtils = require 'yun-ui-kit/utils/domUtils'
{build: _} = reactUtils = require 'yun-ui-kit/utils/reactUtils'

Popover = React.createFactory require 'yun-ui-kit/Popover'
blockScroll = require 'yun-ui-kit/helpers/blockScroll'
EventListener = React.createFactory require 'yun-ui-kit/helpers/EventListener'

{all, always, any, chain, difference, equals, filter, find, has, into, isNil, last, map, once, over, path, pick, reduce, test, type, without} = R = require 'ramda' #auto_require:ramda
{cc, mergeOrEvolve, ymap} = require 'ramda-extras'

Churchill = "We shall go on to the end. We shall fight in France, we shall fight
on the seas and oceans, we shall fight with growing confidence and growing
strength in the air, we shall defend our island, whatever the cost may be.
We shall fight on the beaches, we shall fight on the landing grounds, we shall
fight in the fields and in the streets, we shall fight in the hills;
we shall never surrender"

Churchill_Sr = "Turning once again, and this time more generally, to the question of invasion, I would observe that there has never been a period in all these long centuries of which we boast when an absolute guarantee against invasion, still less against serious raids, could have been given to our people. In the days of Napoleon, of which I was speaking just now, the same wind which would have carried his transports across the Channel might have driven away the blockading fleet. There was always the chance, and it is that chance which has excited and befooled the imaginations of many Continental tyrants. Many are the tales that are told. We are assured that novel methods will be adopted, and when we see the originality of malice, the ingenuity of aggression, which our enemy displays, we may certainly prepare ourselves for every kind of novel stratagem and every kind of brutal and treacherous manœuvre. I think that no idea is so outlandish that it should not be considered and viewed with a searching, but at the same time, I hope, with a steady eye. We must never forget the solid assurances of sea power and those which belong to air power if it can be locally exercised.

I have, myself, full confidence that if all do their duty, if nothing is neglected, and if the best arrangements are made, as they are being made, we shall prove ourselves once more able to defend our island home, to ride out the storm of war, and to outlive the menace of tyranny, if necessary for years, if necessary alone. At any rate, that is what we are going to try to do. That is the resolve of His Majesty's Government – every man of them. That is the will of Parliament and the nation. The British Empire and the French Republic, linked together in their cause and in their need, will defend to the death their native soil, aiding each other like good comrades to the utmost of their strength.

Even though large tracts of Europe and many old and famous States have fallen or may fall into the grip of the Gestapo and all the odious apparatus of Nazi rule, we shall not flag or fail. We shall go on to the end. We shall fight in France, we shall fight on the seas and oceans, we shall fight with growing confidence and growing strength in the air, we shall defend our island, whatever the cost may be. We shall fight on the beaches, we shall fight on the landing grounds, we shall fight in the fields and in the streets, we shall fight in the hills; we shall never surrender, and if, which I do not for a moment believe, this island or a large part of it were subjugated and starving, then our Empire beyond the seas, armed and guarded by the British Fleet, would carry on the struggle, until, in God's good time, the New World, with all its power and might, steps forth to the rescue and the liberation of the old."

Churchill_Jr = "We shall fight on the beaches... we shall never surrender"
# Churchill_Jr = "We shall fight on the beaches..."

Churchill_Quotes = ["“It is a good thing for an uneducated man to read books of quotations.”",
"“There are a terrible lot of lies going about the world, and the worst of it is that half of them are true.”",
"“To build may have to be the slow and laborious task of years. To destroy can be the thoughtless act of a single day.”",
"“To improve is to change, so to be perfect is to change often.”",
"“The farther backward you can look, the farther forward you are likely to see.”",
"“The price of greatness is responsibility.”",
"“Men occasionally stumble over the truth, but most of them pick themselves up and hurry off as if nothing ever happened.”",
"“Never hold discussions with the monkey when the organ grinder is in the room.”",
"“One ought never to turn one’s back on a threatened danger and try to run away from it. If you do that, you will double the danger. But if you meet it promptly and without flinching, you will reduce the danger by half.”",
"“Personally I’m always ready to learn, although I do not always like being taught.”",
"“Success is the ability to go from one failure to another with no loss of enthusiasm.”",
"“Broadly speaking short words are best and the old words when short, are best of all.”",
"“Courage is rightly esteemed the first of human qualities because it has been said, it is the quality which guarantees all others.”",
"“Every day you may make progress. Every step may be fruitful. Yet there will stretch out before you an ever-lengthening, ever-ascending, ever-improving path. You know you will never get to the end of the journey. But this, so far from discouraging, only adds to the joy and glory of the climb.”",
"“History will be kind to me for I intend to write it.”",
"“Attitude is a little thing that makes a BIG difference.”",
"“Success is not final, failure is not fatal, it is the courage to continue that counts.”",
"“If you’re going through hell, keep going.”",
"“Everyone has his day, and some days last longer than others.”",
"“You have enemies? Good. It means you’ve stood up for something, sometime in your life.”",
"“Politics is the ability to foretell what is going to happen tomorrow, next week, next month and next year. And to have the ability afterwards to explain why it didn’t happen.”",
"“Writing a book is an adventure. To begin with it is a toy then an amusement. Then it becomes a mistress, and then it becomes a master, and then it becomes a tyrant and, in the last stage, just as you are about to be reconciled to your servitude, you kill the monster and fling him to the public.”",
"“Those who can win a war well can rarely make a good peace, and those who could make a good peace would never have won the war.”",
"“If you will not fight for right when you can easily win without blood shed; if you will not fight when your victory is sure and not too costly; you may come to the moment when you will have to fight with all the odds against you and only a precarious chance of survival. There may even be a worse case. You may have to fight when there is no hope of victory, because it is better to perish than to live as slaves.”",
"“Never, never, never believe any war will be smooth and easy, or that anyone who embarks on the strange voyage can measure the tides and hurricanes he will encounter. The statesman who yields to war fever must realize that once the signal is given, he is no longer the master of policy but the slave of unforeseeable and uncontrollable events.”",
"“We shape our dwellings, and afterwards our dwellings shape us.”",
"“We shall not fail or falter. We shall not weaken or tire. Neither the sudden shock of battle nor the long-drawn trials of vigilance and exertion will wear us down. Give us the tools and we will finish the job.”",
"“What is adequacy? Adequacy is no standard at all.”",
"“There is always much to be said for not attempting more than you can do and for making a certainty of what you try. But this principle, like others in life and war, has it exceptions.”",
"“There is only one duty, only one safe course, and that is to try to be right and not to fear to do or say what you believe to be right.”",
"“In the course of my life I have often had to eat my words, and I must confess that I have always found it a wholesome diet.”",
"“Every man should ask himself each day whether he is not too readily accepting negative solutions.”",
"“It is wonderful what great strides can be made when there is a resolute purpose behind them.”",
"“The first duty of the university is to teach wisdom, not a trade; character, not technicalities. We want a lot of engineers in the modern world, but we do not want a world of engineers.”",
"“In finance, everything that is agreeable is unsound and everything that is sound is disagreeable.”",
"“All I can say is that I have taken more out of alcohol than alcohol has taken out of me.”",
"“This is the lesson: never give in, never give in, never, never, never, never — in nothing, great or small, large or petty — never give in except to convictions of honour and good sense. Never yield to force; never yield to the apparently overwhelming might of the enemy.”",
"“The greatest lesson in life is to know that even fools are right sometimes.”",
"“All the greatest things are simple, and many can be expressed in a single word: freedom; justice; honour; duty; mercy; hope.”",
"“The whole history of the world is summed up in the fact that when nations are strong they are not always just, and when they wish to be just, they are often no longer strong.”",
"“I like pigs. Dogs look up to us. Cats look down on us. Pigs treat us as equals.”",
"“If we open a quarrel between the past and the present we shall find that we have lost the future.”",
"“It is a mistake to try to look too far ahead. The chain of destiny can only be grasped one link at a time.”",
"“It’s not enough that we do our best; sometimes we have to do what’s required.”",
"“The problems of victory are more agreeable than those of defeat, but they are no less difficult.”",
"“When the eagles are silent, the parrots begin to jabber.”",
"“Out of intense complexities, intense simplicities emerge.”",
"“Courage is what it takes to stand up and speak, it’s also what it takes to sit down and listen.”",
"“Continuous effort – not strength or intelligence – is the key to unlocking our potential.”",
"“If you have an important point to make, don’t try to be subtle or clever. Use a pile driver. Hit the point once. Then come back and hit it again. Then hit it a third time-a tremendous whack.”"]


PopoverDemo = React.createClass
	displayName: 'PopoverDemo'

	getInitialState: ->
		openId: null
		anchorEl: null

	render: ->
		div {},
			h2 {}, 'Popover'
			p {}, 'Simple Popover'
			br()
			input {type: 'button', value: 'Open Popover', onClick: @open('default')}
			Popover
				isOpen: @state.openId == 'default'
				anchorEl: @state.anchorEl
				onRequestClose: (reason) => @close()
			,
				div {style: {background: '#fff'}}, 'This is some simple content'
				input {type: 'button', value: 'Close', onClick: @close}
			br()
			br()
			p {}, 'Placements'
			div {style: {display: 'flex', flexDirection: 'column', alignItems: 'center'}},
				div {style: {display: 'flex'}},
					@popover 'top-right', 'placement-top-right'
					@popoverButton 'top-right', 'placement-top-right'
					@popover 'top-center', 'placement-top-center'
					@popoverButton 'top-center', 'placement-top-center'
					@popover 'top-left', 'placement-top-left'
					@popoverButton 'top-left', 'placement-top-left'
				div {style: {display: 'flex'}},
					@popover 'left-top', 'placement-left-top'
					@popoverButton 'left-top', 'placement-left-top'
					@popover 'left-center', 'placement-left-center'
					@popoverButton 'left-center', 'placement-left-center'
					@popover 'left-bottom', 'placement-left-bottom'
					@popoverButton 'left-bottom', 'placement-left-bottom'
				div {style: {display: 'flex'}},
					@popover 'right-top', 'placement-right-top'
					@popoverButton 'right-top', 'placement-right-top'
					@popover 'right-center', 'placement-right-center'
					@popoverButton 'right-center', 'placement-right-center'
					@popover 'right-bottom', 'placement-right-bottom'
					@popoverButton 'right-bottom', 'placement-right-bottom'
				div {style: {display: 'flex'}},
					@popover 'bottom-right', 'placement-bottom-right'
					@popoverButton 'bottom-right', 'placement-bottom-right'
					@popover 'bottom-center', 'placement-bottom-center'
					@popoverButton 'bottom-center', 'placement-bottom-center'
					@popover 'bottom-left', 'placement-bottom-left'
					@popoverButton 'bottom-left', 'placement-bottom-left'
			br()
			br()
			p {}, 'Placements 2'
			div {style: {display: 'flex', flexDirection: 'column', alignItems: 'center'}},
				div {style: {display: 'flex'}},
					@popover 'top-left', 'placement-top-left2'
					@popoverButton 'top-left', 'placement-top-left2'
					@popover 'top-center', 'placement-top-center2'
					@popoverButton 'top-center', 'placement-top-center2'
					@popover 'top-right', 'placement-top-right2'
					@popoverButton 'top-right', 'placement-top-right2'
				div {style: {display: 'flex'}},
					@popover 'left-bottom', 'placement-left-bottom2'
					@popoverButton 'left-bottom', 'placement-left-bottom2'
					@popover 'left-center', 'placement-left-center2'
					@popoverButton 'left-center', 'placement-left-center2'
					@popover 'left-top', 'placement-left-top2'
					@popoverButton 'left-top', 'placement-left-top2'
				div {style: {display: 'flex'}},
					@popover 'right-bottom', 'placement-right-bottom2'
					@popoverButton 'right-bottom', 'placement-right-bottom2'
					@popover 'right-center', 'placement-right-center2'
					@popoverButton 'right-center', 'placement-right-center2'
					@popover 'right-top', 'placement-right-top2'
					@popoverButton 'right-top', 'placement-right-top2'
				div {style: {display: 'flex'}},
					@popover 'bottom-left', 'placement-bottom-left2'
					@popoverButton 'bottom-left', 'placement-bottom-left2'
					@popover 'bottom-center', 'placement-bottom-center2'
					@popoverButton 'bottom-center', 'placement-bottom-center2'
					@popover 'bottom-right', 'placement-bottom-right2'
					@popoverButton 'bottom-right', 'placement-bottom-right2kj'
			br()
			br()
			p {}, 'Long content (automatically cut)'
			div {style: {display: 'flex', flexDirection: 'column', alignItems: 'center'}},
				div {style: {display: 'flex'}},
					@popover 'top-left', 'placement-top-left-long'
					@popoverButton 'top-left', 'placement-top-left-long'
					@popover 'top-center', 'placement-top-center-long'
					@popoverButton 'top-center', 'placement-top-center-long'
					@popover 'top-right', 'placement-top-right-long'
					@popoverButton 'top-right', 'placement-top-right-long'
				div {style: {display: 'flex'}},
					@popover 'left-bottom', 'placement-left-bottom-long'
					@popoverButton 'left-bottom', 'placement-left-bottom-long'
					@popover 'left-center', 'placement-left-center-long'
					@popoverButton 'left-center', 'placement-left-center-long'
					@popover 'left-top', 'placement-left-top-long'
					@popoverButton 'left-top', 'placement-left-top-long'
				div {style: {display: 'flex'}},
					@popover 'right-bottom', 'placement-right-bottom-long'
					@popoverButton 'right-bottom', 'placement-right-bottom-long'
					@popover 'right-center', 'placement-right-center-long'
					@popoverButton 'right-center', 'placement-right-center-long'
					@popover 'right-top', 'placement-right-top-long'
					@popoverButton 'right-top', 'placement-right-top-long'
				div {style: {display: 'flex'}},
					@popover 'bottom-left', 'placement-bottom-left-long'
					@popoverButton 'bottom-left', 'placement-bottom-left-long'
					@popover 'bottom-center', 'placement-bottom-center-long'
					@popoverButton 'bottom-center', 'placement-bottom-center-long'
					@popover 'bottom-right', 'placement-bottom-right-long'
					@popoverButton 'bottom-right', 'placement-bottom-right-long'
			br()
			br()
			p {}, 'Content that resize itself (automatically cut)'
			div {style: {display: 'flex', flexDirection: 'column', alignItems: 'center'}},
				div {style: {display: 'flex'}},
					@popover 'top-left', 'placement-top-left-resize'
					@popoverButton 'top-left', 'placement-top-left-resize'
					@popover 'top-center', 'placement-top-center-resize'
					@popoverButton 'top-center', 'placement-top-center-resize'
					@popover 'top-right', 'placement-top-right-resize'
					@popoverButton 'top-right', 'placement-top-right-resize'
				div {style: {display: 'flex'}},
					@popover 'left-bottom', 'placement-left-bottom-resize'
					@popoverButton 'left-bottom', 'placement-left-bottom-resize'
					@popover 'left-center', 'placement-left-center-resize'
					@popoverButton 'left-center', 'placement-left-center-resize'
					@popover 'left-top', 'placement-left-top-resize'
					@popoverButton 'left-top', 'placement-left-top-resize'
				div {style: {display: 'flex'}},
					@popover 'right-bottom', 'placement-right-bottom-resize'
					@popoverButton 'right-bottom', 'placement-right-bottom-resize'
					@popover 'right-center', 'placement-right-center-resize'
					@popoverButton 'right-center', 'placement-right-center-resize'
					@popover 'right-top', 'placement-right-top-resize'
					@popoverButton 'right-top', 'placement-right-top-resize'
				div {style: {display: 'flex'}},
					@popover 'bottom-left', 'placement-bottom-left-resize'
					@popoverButton 'bottom-left', 'placement-bottom-left-resize'
					@popover 'bottom-center', 'placement-bottom-center-resize'
					@popoverButton 'bottom-center', 'placement-bottom-center-resize'
					@popover 'bottom-right', 'placement-bottom-right-resize'
					@popoverButton 'bottom-right', 'placement-bottom-right-resize'
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()
			br()

	popover: (placement, id) ->
		Popover
			isOpen: @state.openId == id
			anchorEl: @state.anchorEl
			placement: placement
			onRequestClose: (reason) => @close()
		,
			if test /-long/, id
				_ blockScroll(div),
					{style: {background: '#fff', width: 150, maxHeight: 'inherit', overflow: 'scroll'}},
					Churchill_Sr

				# EventListener
				# 	key: 2
				# 	element: window
				# 	onWheel: (e) =>
				# 		# Research around this concludes you cannot cancel the scroll event
				# 		# but you can cancel the events provoking the scroll event
				# 		# http://stackoverflow.com/questions/4770025/how-to-disable-scrolling-temporarily
				# 		# http://stackoverflow.com/questions/8813051/determine-which-element-the-mouse-pointer-is-on-top-of-in-javascript

				# 		hoveredElement = document.elementFromPoint e.clientX, e.clientY
				# 		if isNil hoveredElement then return

				# 		longEl = @refs.longPopover

				# 		if isNil longEl then return

				# 		if !domUtils.isDescendant longEl, hoveredElement then return

				# 		# console.log longEl.scrollTop, longEl.scrollHeight, longEl.scrollTop + longEl.offsetHeight

				# 		# console.log e.deltaY
				# 		if e.deltaY > 0
				# 			newScroll = longEl.scrollTop + longEl.offsetHeight + e.deltaY
				# 			# console.log newScroll, '>=', longEl.scrollHeight
				# 			if newScroll >= longEl.scrollHeight
				# 				longEl.scrollTop = longEl.scrollHeight - longEl.offsetHeight
				# 				e.preventDefault()
				# 			else
				# 				console.log e.deltaY


				# 		else if e.deltaY < 0
				# 			newScroll = longEl.scrollTop + e.deltaY
				# 			# console.log newScroll, '<=', 0
				# 			if newScroll <= 0
				# 				longEl.scrollTop = 0
				# 				e.preventDefault()
				# 			else
				# 				console.log e.deltaY
				# ]
			else if test /-resize/, id
				renderItem = (q) ->
					div {key: q, style: {padding: 20}}, q

				filterFn = test(new RegExp(@state.filter, 'i'))

				div {style: {width: 350, maxHeight: 'inherit', display: 'flex', flexDirection: 'column'}},
					div {style: {padding: 20}},
						p {}, 'Search Churchill Quotes'
						input
							type: 'text'
							value: @state.filter
							onChange: (e) => @setState {filter: e.currentTarget.value}
					div {style: {overflow: 'scroll'}},
						cc map(renderItem), filter(filterFn), Churchill_Quotes
			else
				div {},
					div {style: {background: '#fff'}}, Churchill_Jr
					input {type: 'button', value: 'Close', onClick: @close}

	popoverButton: (placement, id) ->
		input {type: 'button', style: {width: 120, margin: 5}, value: placement, onClick: @open(id)}

	open: (id) -> (e) =>
		@setState {openId: id, anchorEl: e.currentTarget}

	close: ->
		@setState {openId: null, anchorEl: null}

module.exports = PopoverDemo
