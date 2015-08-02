# This imports all the layers for "Filmie" into filmieLayers
cardWidth = 281*2
cardHeight = 401*2
avatarWidth = 75*2

Array::remove = (obj) ->
  @filter (el) -> el isnt obj
  
userHoverCard = false

cardDetailsPageScroll = false

cardClicked = false

filmNameStyle = "style = 'color:black; font-size:54px; line-height: 54px; font-weight:600; '"

filmNameLocalStyle = "style = 'color:black; font-size:34px; line-height: 54px;'"

filmDescLocalStyle = "style = 'color:black; font-size:30px; line-height: 45px; padding:0 40px 20px 40px; '"

filmDetailsLocalStyle = "style = 'color:black; font-size:30px; line-height: 45px; padding:0 40px 20px 40px;'"

bStyle = "style = 'line-height:120px;'"

personNameLocalStyle = "style = 'color:white; font-size:24px; line-height: 34px; text-align:center;'"

personNameLocalBlackStyle = "style = 'color:black; font-size:24px; line-height: 34px; text-align:center;'"

bgLayer = new Layer
	x:-100, y:-100, width:Screen.width+100, height:Screen.height+100, image:"images/p2251044132.jpg"

bgLayer.blur = 90
bgLayer.brightness = 30

persons = [{"name":"保罗·费格", "role": "director", "avatar":"images/1359535205.49.jpg"},
{"name":"梅丽莎·麦卡西", "role": "actor", "avatar":"images/1369909970.71.jpg"},
{"name":"裘德·洛", "role": "actor", "avatar":"images/4952.jpg"},
{"name":"杰森·斯坦森", "role": "actor", "avatar":"images/424.jpg"}]

filmImages = ["images/p2239437855.jpg","images/p2248366305.jpg", "images/p2248366580.jpg"]

cards = [{name:"Spy", local:"女间谍", image:"images/p2251044132.jpg", desc: "中情局分析师苏珊（梅丽莎·麦卡西 Melissa McCarthy 饰）是位专门协助处理危险任务却不为人知的后勤人员，她的搭档布莱德利（裘德·洛 Jude Law 饰）...", persons: persons, filmImages: filmImages}, 
{"name":"San Andreas","local":"末日崩塌","image":"images/p2246671006.jpg", persons: persons, filmImages: filmImages}, 
{"name":"MAD MAX","local":"疯狂的麦克斯","image":"images/p2244555657.jpg", persons: persons, filmImages: filmImages}]


container = new Layer
	x:0, y:0, width:Screen.width, height:Screen.height, backgroundColor: "transparent"
	
cardsLayers = []
cardsY = []

createFilmImage = (imagePath, i, container) ->
	return new Layer x:(i*610), y:0, width:600, height:446 , image:imagePath, superLayer: container

createPerson = (person, i, parent, shadowColor, style) ->
	personLayer = new Layer
		x: 50 + (i*250), y:0,
		width: avatarWidth,
		height: avatarWidth + 46,
		backgroundColor: "transparent",
		superLayer: parent,
		clip:false
	
	personLayer.on Events.Click, ->
		personBubble.states.next()
		
	avatar = new Layer
		x:0, y:0, width:personLayer.width,
		height:personLayer.width, 
		image:"#{person.avatar}",
		cornerRadius: personLayer.width/2.0,
		superLayer: personLayer,
		shadowY: 4,
		shadowBlur: 8,
		shadowColor: shadowColor
		
	personName = new Layer
		x:0, y:personLayer.height - 30, width:personLayer.width,
		height:36,
		html: "<div #{style}>#{person.name}</div>"
		backgroundColor: "transparent"
		superLayer: personLayer
		
	return person

cardContainer = new Layer
	name: "cardContainer"
	x:0, y: 0, width:Screen.width,
	height:cardHeight + 200, 
	backgroundColor: "transparent",
	superLayer: container,
	opacity: 0.0,
	scale: 0.8,
	clip: false


# Create ScrollComponent
personScrol = new ScrollComponent
	width: Screen.width
	height: avatarWidth + 46
	y: Screen.height
	scrollHorizontal: true
	scrollVertical: false
	opacity: 1
	contentInset:
		right: 50
	backgroundColor: "rgba(255,255,255,0.0)"

cardContainer.animate
    properties:
	    opacity: 1.0
	    scale: 1.0
    curve: "ease-in-out"
    time: 0.5
    
personScrol.animate
    properties:
    	y: Screen.height - avatarWidth - 80
	    scale: 1.0
    curve: "spring(200, 20, 0)"
    time: 0.5
    
findLayerByName = (name, cardOne) ->
	layers = cardOne.subLayersByName name
	return layers[0]

findLayerByNameOnScrollContent = (name, scrollContent) ->
	layers = scrollContent.content.subLayersByName name
	return layers[0]
	

addCardEvent = (cardOne) ->
	cardOne.draggable.enabled = true
	cardOne.draggable.vertical = false
	
	animationA = new Animation({
	    layer: cardOne,
	    properties: 
	      x:0,
	      y:0,
	      width:Screen.width,
	      height:Screen.height
	    curve: "ease-in-out"
	    time: 0.15
	})
	
	animationB = animationA.reverse()
	
	animationActor = new Animation({
	    layer: personScrol,
	    properties: 
	      y: personScrol.y + personScrol.height + 50
	    curve: "spring(400, 20, 0)"
	})
	
	animationActorB = new Animation({
	    layer: personScrol,
	    properties: 
	      y: Screen.height - avatarWidth - 80
	    curve: "spring(200, 20, 0)"
	})
	
	cardScroll = findLayerByName "cardScroll", cardOne

	startLayer = findLayerByNameOnScrollContent "startLayer", cardScroll
	
	animationStar =  new Animation({
	    layer: startLayer,
	    properties: 
	      x:Screen.width - 140 - 40,
	      scale: 1.0
	    curve: "ease-in-out"
	    time: 0.15
	})
	
	animationStarB = animationStar.reverse()
# 	animationA.on Events.AnimationStop, ->
# 		cardClicked = false
		
	animationA.on Events.AnimationStart, ->
		cardClicked = true
		cardOne.draggable.enabled = false
		
	animationB.on Events.AnimationStart, ->
		cardScroll.content.removeSubLayer findLayerByNameOnScrollContent "filmImages", cardScroll
	
	animationB.on Events.AnimationStop, ->
		cardClicked = false
		cardOne.draggable.enabled = true

	animationA.on Events.AnimationStop, ->
		filmImages = new Layer
			name: "filmImages"
			x:0, y:2162, width:Screen.width ,
			height: 560,
			html: "<div #{filmDetailsLocalStyle}><b #{bStyle}>剧照</b></div>"
			backgroundColor: "transparent"
			superLayer: cardScroll.content
	
			
		for image, i in card.filmImages
			image = createFilmImage image, i, filmImages
	
	cardOne.on "change:width", ->
# 		print "Card width changed"
		cardScroll.width = cardOne.width
		
		fixBG = findLayerByName "fixBG", cardOne
		
		fixBG.width = cardOne.width
		
		poster = findLayerByNameOnScrollContent "poster", cardScroll
		poster.width = cardOne.width
	
	cardOne.on Events.Click, ->
		
# 		print "User Clicked"
		if userHoverCard || cardDetailsPageScroll
			return
			
		if cardClicked 
			animationB.start()
			animationActorB.start()
			animationStarB.start()
			cardScroll.scrollVertical = false
			
		else
			cardOne.bringToFront()
			cardScroll.scrollVertical = true
			
			animationStar.start()
			
			animationActor.start()
			animationA.start()

	
	cardOne.on Events.DragMove, ->
# 		print "User Drag"
		userHoverCard = true
		for card, i in cardsLayers
			if i != 0
				card.animateStop()
		progress = cardDragProgress()
# 			print "Dragging #{progress}"
		handleCardStatusWithProgress progress
		
	
	cardOne.on Events.DragEnd, ->
# 		print "User Drag End"
		if cardClicked
			return
		userHoverCard = false
		progress = cardDragProgress()
		velocity = Math.abs cardsLayers[0].draggable.velocity.x
# 			print "Drag End #{progress} Card #{velocity}"
		
		if progress > 0.35 || velocity > 1.5
# 				print "Move Card Out"
			addCardEvent cardsLayers[1]
			handleFirstCardWithState true
			fakeLayer.x = 100*progress
			fakeLayer.animate
			    properties:
			      x: 100
			    curve: "ease-in-out",
			    time: 0.45
		else
# 				print "Move Card Back"
			handleFirstCardWithState false
			fakeLayer.x = 100*progress
			fakeLayer.animate
			    properties:
			      x: 0
			    curve: "ease-in-out",
			    time: 0.45

createCard = (card, scale, brightness) ->
	
	finalY = 130+(cardHeight/2 - cardHeight/2*scale)
	
	cardOne = new Layer
		x:Screen.width/2 - cardWidth/2.0, y:finalY, 
		width:cardWidth, 
		height:cardHeight, 
		backgroundColor: "white",
		cornerRadius: 16,
		shadowY: 4,
		shadowBlur: 8,
		shadowColor: "RGBA(0, 0, 0, 0.4)",
		superLayer: cardContainer,
		scale: scale,
		brightness: brightness
# 		borderColor: "black",
# 		borderWidth: 1
	
	FixBG = new Layer
		name: "fixBG"
		x:0, y:0, width:cardOne.width,
		height:cardOne.height*0.79, 
		force2d: true,
		backgroundColor: "black"
		superLayer: cardOne
	
	cardScroll = new ScrollComponent
		name: "cardScroll",
		backgroundColor: "white",
		width: cardOne.width,
		height: Screen.height,
		scrollHorizontal: false,
		scrollVertical: true,
		clip: true,
		superLayer: cardOne
		
	cardScroll.on Events.Scroll, ->
		cardDetailsPageScroll = true
	cardScroll.on Events.ScrollEnd, ->
		cardDetailsPageScroll = false
		
	cardScroll.scrollVertical = false
	
	poster = new Layer
		name: "poster"
		x:0, y:0, width:cardOne.width,
		height:cardOne.height*0.79, 
		image:"#{card.image}",
		superLayer: cardScroll.content
		
	filmName = new Layer
		x:40, y:cardOne.height - 140, width:cardOne.width,
		height:140,
		html: "<span #{filmNameStyle}>#{card.name}</span>"
		backgroundColor: "transparent"
		superLayer: cardScroll.content
		
	startLayer = new Layer
		name: "startLayer"
		x:cardWidth - 140 - 20, y:filmName.y + 56/2.0, width:140, height:56, image:"images/Star.png",
		scale: 0.7,
		superLayer: cardScroll.content
		
	filmNameLocal = new Layer
		x:40, y:cardOne.height - 80, width:cardOne.width,
		height:140,
		html: "<span #{filmNameLocalStyle}>#{card.local}</span>"
		backgroundColor: "transparent"
		superLayer: cardScroll.content
	
	filmDescLocal = new Layer
		x:0, y:cardOne.height + 10, width:Screen.width ,
		height: 210,
		html: "<div #{filmDescLocalStyle}>#{card.desc}</div>"
		backgroundColor: "transparent"
		superLayer: cardScroll.content
		
	filmDetails = new Layer
		x:0, y:cardOne.height + 10 + filmDescLocal.height, width:Screen.width ,
		height: 420,
		html: "<div #{filmDetailsLocalStyle}><b #{bStyle}>影片资料</b><br>类型: 喜剧 / 动作 / 犯罪<br>上映日期: 2015-06-05(美国) / 2015-05-21(澳大利亚)<br>片长: 120分钟<br>制片国家/地区: 美国<br>IMDb链接: tt3079380<br></div>"
		backgroundColor: "transparent"
		superLayer: cardScroll.content
		
	filmDI = new Layer
		x:0, y:cardOne.height + 10 + filmDescLocal.height + filmDetails.height, width:Screen.width ,
		height: 360,
		html: "<div #{filmDetailsLocalStyle}><b #{bStyle}>导演 ／ 编剧</b></div>"
		backgroundColor: "transparent"
		superLayer: cardScroll.content
		
	diector = createPerson card.persons[0], 0, filmDI, "transparent", personNameLocalBlackStyle

	filmActors = new Layer
		x:0, y:cardOne.height + 10 + filmDescLocal.height + filmDetails.height + filmDI.height, width:Screen.width ,
		height: 360,
		html: "<div #{filmDetailsLocalStyle}><b #{bStyle}>主演</b></div>"
		backgroundColor: "transparent"
		superLayer: cardScroll.content
	
	for actor, i in card.persons
		if i != 0
			actor = createPerson actor, i-1, filmActors, "transparent", personNameLocalBlackStyle

	return cardOne
	
configCard = (card, i) ->
	brightness = 100 * (0.85**i)
	scale = 0.9**i
	
	cardOne = createCard card, scale, brightness
		
	cardsY.push cardOne.y

	cardsLayers.push cardOne
	cardOne.animate
	    properties:
	      y: cardOne.y + (i*20)
	    curve: "ease-in-out"
	    time: 0.5
	    
	 cardOne.sendToBack()
	return cardOne


for card, i in cards
	cardOne = configCard card, i
	
	if i == 0		

		beforeDragX = cardOne.x
		cardCenter = Screen.width
		addCardEvent cardOne

	
fakeLayer = new Layer
	x:0, y:0,
	width:0, height:0
	opacity: 0
		
fakeLayer.on "change:x", ->
	progress = fakeLayer.x/100
	handleCardStatusWithProgress progress

handleFirstCardWithState = (out) ->
	firstCard = cardsLayers[0]
	if (firstCard.x > 96 && out)
		firstCard.animate
	    properties:
	      x: 1310
	      rotationZ:0
	    curve: "ease-in-out",
	    time: 0.5
	    
	    addDeleteEvent firstCard
	else if (firstCard.x > 96 && !out) || (firstCard.x < 96 && !out)
		firstCard.animate
	    properties:
	      x: 96
	      rotationZ:0
	    curve: "spring(200, 15, 0)",
	    time: 0.3
	else if firstCard.x < 0 && out
		firstCard.animate
	    properties:
	      x: -980
	      rotationZ:0
	    curve: "ease-in-out",
	    time: 0.5
	    addDeleteEvent firstCard

cardMoveLeft = (firstCard) ->
	if firstCard.x < 96
		return true
	else if firstCard.x >= 96
		return false
		

addDeleteEvent = (firstCard) ->
	firstCard.on Events.AnimationStop, ->
# 		print "Delete First Card" 
		cardsLayers.splice(0, 1)
		addNewCard()

addNewCard = ->
	card = cards[Math.floor(Math.random() * cards.length)]
# 	print "createCard" 
	
	i = 2
	cardOne = configCard card, i
	
	cardOne.animate
	    properties:
	      y: cardOne.y + (i*20)
	    curve: "spring(100, 10, 0)",
	    time: 0.3
	
cardDragProgress = ->
	firstCardX = cardsLayers[0].x
# 	print "Card First X is #{firstCardX}"
	if firstCardX >= 0 && firstCardX <= beforeDragX
		firstCardX = beforeDragX - firstCardX
	else if firstCardX < 0
		firstCardX = beforeDragX + Math.abs firstCardX
	else if firstCardX > beforeDragX
		firstCardX = firstCardX - beforeDragX
	
	progress = firstCardX / cardCenter
	return progress
	
handleCardStatusWithProgress = (progress) ->
	
	if progress > 1.0
		return

	if cardClicked
		return
		
# 	print "Change State"
	for card, i in cardsLayers
		originScale = 0.9**(i)
		scale = originScale + (progress/0.5)*0.1
		finalCardScale = 0.9**(i-1)
		toScale = finalCardScale - scale
		toScale = 0 if toScale < 0
		currentScale = scale - originScale
		scalingProgress = currentScale / toScale
		scaleProgress = scale/finalCardScale
# 		print scalingProgress
# 		print currentScale, toScale

		scalingProgress = 1.0 if scalingProgress >= 1.0
		scalingProgress = 0.0 if scalingProgress <= 0
		
		if i == 0 && userHoverCard
# 			print scalingProgress
			if cardMoveLeft card
				card.rotationZ = 15*scalingProgress
			else
				card.rotationZ = -15*scalingProgress
		
		if i > 0
			originY = cardsY[i] + i * 20
			finalY = cardsY[i-1] + (i-1) * 20
			
			originBR = 100 * 0.85**i
			finalBR = 100 * 0.85**(i-1)
			
			if scaleProgress <= 1.0
				card.scale = scale
				brightness = originBR + (finalBR - originBR)*scalingProgress
				card.brightness = brightness 				if brightness <= 100
				y = originY - (originY - finalY)*scalingProgress
				card.y = y

indicatorLayer = new Layer
	x:Screen.width - 30, 
	y:Screen.height - 26 - (avatarWidth + 46)/2.0 - 18, 
	width:16, height:26, image:"images/Indicator.png",
	opacity: 0.3
	
personScrol.on Events.Scroll, ->
	if personScrol.scrollX > avatarWidth
		indicatorLayer.opacity = 0.0
	else
		indicatorLayer.opacity = 0.3

	
for person, i in persons
	createPerson person, i, personScrol.content, "RGBA(0, 0, 0, 0.4)", personNameLocalStyle

personBubble = new Layer
	x:0, y:-1016, width:684, height:1016, image:"images/Bubble.png", opacity: 0
personBubble.center()
personBubble.y = -1016

personBubble.states.add({
    stateA: {y:50, opacity: 1.0}
})

personBubble.states.animationOptions = {
    curve: "spring(200, 20, 0)"
}
