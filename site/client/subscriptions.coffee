# Deps.autorun ->
#     gamesSub = Meteor.subscribe "gamesPub"

#     result = Session.get "newGameResult"
#     playersSub = Meteor.subscribe "playersPub", result

#     gameNum = Session.get "plotGameNum"
#     plotDataSub = Meteor.subscribe "plotDataPub", gameNum
#   