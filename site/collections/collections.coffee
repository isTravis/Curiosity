# Define the collections and their ties to the mongodb names
@WikiLinks = new Meteor.Collection "wikilinks" #Stores the outgoing links from each page. Sorted by ID
@TopMillion = new Meteor.Collection "topmillion" #Stores all the data about a specific article
@UserData = new Meteor.Collection "userdata"


# @UserGridData = new Meteor.Collection "usergriddata"
# @WikiData = new Meteor.Collection "wikidata" 
# @isReady = new Meteor.Collection "links"
# @TopPages = new Meteor.Collection "toppages"
# @PageIDs = new Meteor.Collection "pageids" #
# @Links = new Meteor.Collection "links"
# @Edges = new Meteor.Collection "edges"
# @ArticleData = new Meteor.Collection "articledata"
# @TopHundredThousand = new Meteor.Collection "tophundredthousand"
# @TopThousand = new Meteor.Collection "topthousand"
# @TopTenThousand = new Meteor.Collection "toptenthousand"