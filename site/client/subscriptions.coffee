Deps.autorun ->
	userTitles = Session.get "userTitles"
	userGridDataSub = Meteor.subscribe "userGridDataPub", userTitles

	clickedItem = Session.get "clickedItem"
	userLinksSub = Meteor.subscribe "userLinksPub", clickedItem

	firstHopSub = Meteor.subscribe "firstHopPub", userTitles
	
	clickedItemSub = Meteor.subscribe "clickedItemPub", clickedItem
    

    # topPagesSub = Meteor.subscribe "topPagesPub", zoom, myx, myy
    # maxNumShown = Session.get "maxNumShown" # Get the session variable
	# receivedHistoryTime = Session.get "receivedHistoryTime"
	# historyValues = Session.get "historyValues"
	# userID = Session.get "userID"
	# # wikiDataSub = Meteor.subscribe "wikiDataPub", historyValues, receivedHistoryTime, userID
	# # Since main.coffee runs in all situations, nneed a way to make sure only the single publication is run
	
	# UserData = Meteor.subscribe "userDataPub", historyValues, receivedHistoryTime, userID

	# zoom = Session.get "zoom"
	# myx = Session.get "myx"
	# myy = Session.get "myy"
	# # topThousandSub = Meteor.subscribe "topThousandPub", zoom
	# # topTenThousandSub = Meteor.subscribe "topTenThousandPub", zoom
	# # topHundredThousandSub = Meteor.subscribe "topHundredThousandPub", zoom, myx, myy
	# topMillionSub = Meteor.subscribe "topMillionPub", zoom, myx, myy

   