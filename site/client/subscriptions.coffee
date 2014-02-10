# Deps.autorun ->
#     gamesSub = Meteor.subscribe "gamesPub"

#     result = Session.get "newGameResult"
#     playersSub = Meteor.subscribe "playersPub", result

#     gameNum = Session.get "plotGameNum"
#     plotDataSub = Meteor.subscribe "plotDataPub", gameNum
#   

# An overview of deps.autorun is documented here: http://docs.meteor.com/#reactivity
Deps.autorun ->
	# maxNumShown = Session.get "maxNumShown" # Get the session variable
	receivedHistoryTime = Session.get "receivedHistoryTime"
	historyValues = Session.get "historyValues"
	userID = Session.get "userID"
	# wikiDataSub = Meteor.subscribe "wikiDataPub", historyValues, receivedHistoryTime, userID
	# Since main.coffee runs in all situations, nneed a way to make sure only the single publication is run
	
	userGridDataSub = Meteor.subscribe "userGridDataPub", historyValues, receivedHistoryTime, userID

	zoom = Session.get "zoom"
	myx = Session.get "myx"
	myy = Session.get "myy"
	topThousandSub = Meteor.subscribe "topThousandPub", zoom
	topTenThousandSub = Meteor.subscribe "topTenThousandPub", zoom
	topHundredThousandSub = Meteor.subscribe "topHundredThousandPub", zoom, myx, myy
	topMillionSub = Meteor.subscribe "topMillionPub", zoom, myx, myy

    # topPagesSub = Meteor.subscribe "topPagesPub", zoom, myx, myy

   