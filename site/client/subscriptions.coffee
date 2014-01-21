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
    # updated = Session.get "updated"
    wikiDataSub = Meteor.subscribe "wikiDataPub"