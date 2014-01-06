#!/usr/bin/python
'''
Script interfaceing with Wiki API to collect first and second links
'''

from lxml import html
import json
import requests
import re
import time
import urllib
import operator
from pprint import pprint
import pickle
import sys

# times = time.time()
# print time.time()-times

json_data = open('mHistory.json')
mHistory = json.load(json_data)
json_data.close()

# pprint(mHistory)

historyTitles = []

for item in mHistory:
	url = mHistory[item][2] # The webpage URL
	count = int(mHistory[item][3]) # The number of times that page was accessed
	for ii in range(count): # Run this for each time the page was accessed, to get fair weighting.
		print str(ii) + " of " + str(count)
		try:
			# print url.split("wiki/")[1]
			parsedURL = url.split("wiki/")[1].split("#")[0]
			if parsedURL.startswith('File:'):
				print 'Discarding File: item'
			else: 
				historyTitles.append(parsedURL)
		except:
			print "bad URL"	

# print historyTitles

masterPageLinks = {} # {page1: [list of links page1 contains], ... , pageN: [list of links pageN contains]}
directPages = {}     # {page1: 4, page2: 13, ... , pageN: 7}
firsthopPages = {}	 # {page1: 4, page2: 13, ... , pageN: 7}
secondhopPages = {}	 # {page1: 4, page2: 13, ... , pageN: 7}

firstHopLinksList = []  # [page1, page2, page3, ... , pageN] 
secondHopLinksList = [] # [page1, page2, page3, ... , pageN] 


def addPageToCount (pageTitle, pageDict):
	#if pageTitle in pageDict
		# increment page title
	# else
		# Add to dict
	# pageTitle = pageTitle.lower()
	if pageTitle in pageDict:
		pageDict[pageTitle] = pageDict[pageTitle] + 1
	else:
		pageDict[pageTitle] = 1

def scrapePage (pageTitle):
	# Not working with ampersands & or colons :. Must fix! Even with the bug, total time -> 296 seconds
	if pageTitle.lower() not in masterPageLinks:
		print " | Not Found in dict"
		#scrape from wiki
		outputJSON = []
		try:
			URL_BASE = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=%(pageTitle)s&prop=revisions&rvprop=content'
			url = URL_BASE % {'pageTitle': pageTitle}
			r = requests.get(url)
			j = r.json()['query']['pages']
			articleNumber = 0
			for children in j:
				articleNumber = children
			mtitle = j[articleNumber]['title'].replace(' ', '_')
			t = j[articleNumber]['revisions'][0]['*']
			quoted = re.compile(r"(?!\[\[Category:.*?\]\])(?!\[\[File:.*?\]\])\[\[(.*?)\]\]")
			listOfLinksfromPage = []
			for value in quoted.findall(t):
				listOfLinksfromPage.append(value.split("|")[0].split("#")[0].replace(' ', '_'))
			masterPageLinks[mtitle.lower()] = listOfLinksfromPage
		except :
			print "Error on " + pageTitle + " | "
			print sys.exc_info()
			listOfLinksfromPage = []
			masterPageLinks[pageTitle.lower()] = listOfLinksfromPage
	else: 
		#call from masterPageLinks
		print " | Found in dict"
		listOfLinksfromPage = masterPageLinks[pageTitle.lower()]
		
	return listOfLinksfromPage

# Bokm%C3%A5l

# How many pages are there with only one hit
countpages = 0
for page in firsthopPages:
	if firsthopPages[page] == 1:
		countpages = countpages + 1
print str(countpages) + " out of " + str(len(firsthopPages))


# Indonesian_killings_of_1965%E2%80%931966

# history = ['Boston','Saudi_Arabia']
# history = ['Quantum_mechanics']
count = 0
count2 = 0
count0 = 0

# 210297
# 166 for 1000
# 164 for 1000
# 270 for 2000

for page in historyTitles:
	#Add page to pageCountDict or increment
	#Scrape page for links
	#Add scraped links to firstHopLinksList
	count0 = count0 +1
	print ("page " + str(count0) + " of " + str(len(historyTitles)) + " | " + page)
	addPageToCount(page, directPages)
	pageLinks = scrapePage(page)
	for firsthopPage in pageLinks:
		firstHopLinksList.append(firsthopPage)

times = time.time()
for page in firstHopLinksList[100:]:
	#Add page to pageCountDict-firsthop or increment
	#Scrape page for links
	#Add scraped links to secondHopLinksList
	count = count + 1
	print ("page " + str(count) + " of " + str(len(firstHopLinksList)) + " | " + page), 
	# print "Start addtoPage"
	addPageToCount(page, firsthopPages)
	# print "Start scrape"
	pageLinks = scrapePage(page)
	# print "Start for"
	for secondhopPage in pageLinks:
		secondHopLinksList.append(secondhopPage)

print time.time()-times


for page in secondHopLinksList:
	# add page to pageCountDict-second hop or increment
	addPageToCount(page, secondhopPages)
	count2 = count2+1 
	print str(count2) + " of " + str(len(secondHopLinksList))

sorted_x = sorted(firsthopPages.iteritems(), key=operator.itemgetter(1))
# max(directPages.iteritems(), key=operator.itemgetter(1))[0]
print sorted_x


# Clean after direct (first function block)
# pickle.dump( masterPageLinks, open( "masterPageLinks_direct.p", "wb" ) )
# pickle.dump( directPages, open( "directPages.p", "wb" ) )
# pickle.dump( firstHopLinksList, open( "firstHopLinksList.p", "wb" ) )


# masterPageLinks = pickle.load(open("masterPageLinks.p", "rb"))  
# directPages = pickle.load(open("directPages.p", "rb"))     
# firsthopPages = pickle.load(open("firsthopPages.p", "rb"))	 
# secondhopPages = pickle.load(open("secondhopPageshalf.p", "rb"))	

firstHopLinksList = pickle.load(open("firstHopLinksList.p", "rb")) 
# secondHopLinksList = pickle.load(open("secondHopLinksList.p", "rb")) 

pickle.dump( masterPageLinks, open( "masterPageLinks.p", "wb" ) ) # Add a timestamp to the end
pickle.dump( firsthopPages, open( "firsthopPages.p", "wb" ) )
pickle.dump( secondHopLinksList, open( "secondHopLinksList.p", "wb" ) )
pickle.dump( secondhopPages, open( "secondhopPages.p", "wb" ) )


# \[\[(.*?)\]\]
# (?!\[\[File:.*?\]\])\[\[(.*?)\]\] 
# (?!\[\[Category:.*?\]\])(?!\[\[File:.*?\]\])\[\[(.*?)\]\]
