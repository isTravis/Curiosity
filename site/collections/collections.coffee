# Define the collections and their ties to the mongodb names
@WikiData = new Meteor.Collection "wikidata"
@PageIDs = new Meteor.Collection "pageids"
@Links = new Meteor.Collection "links"
@Edges = new Meteor.Collection "edges"
@ArticleData = new Meteor.Collection "articledata"
@TopHundredThousand = new Meteor.Collection "tophundredthousand"
@TopThousand = new Meteor.Collection "topthousand"
@TopTenThousand = new Meteor.Collection "toptenthousand"
@TopMillion = new Meteor.Collection "topmillion"
@SelectMillion = new Meteor.Collection "selectmillion"
# @isReady = new Meteor.Collection "links"

@TopPages = new Meteor.Collection "toppages"
