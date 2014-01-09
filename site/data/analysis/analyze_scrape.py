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



# # Generate normalized pageCounts
# # Load in the page count data, looks like: {page1: 4, page2: 13, ... , pageN: 7}
# # For each page, find the associated entry in masterPage Links, and count the number of links that page has: len(pageLinks)
# # Divide the pagecount data number by that pageLinkCount number, to normalize results.
# # Won't work for the secondHop Link since we haven't scraped all the second hop links. 

# masterPageLinks = pickle.load(open("../datasets/masterPageLinks.p", "rb"))  
# directPages = pickle.load(open("../datasets/directPages.p", "rb")) 
# firsthopPages = pickle.load(open("../datasets/firsthopPages.p", "rb"))
# secondhopPages = pickle.load(open("../datasets/secondhopPages.p", "rb"))

# directPages_normalized = directPages
# firsthopPages_normalized = firsthopPages
# secondhopPages_normalized = secondhopPages

# for page in directPages_normalized:
# 	# For each page, check to make sure the page is in masterLinks
# 	# If it is, get the length of that link in Master pages
# 	# directPages_normalized[page] = 0
# 	try:
# 		numHits = float(directPages_normalized[page])
# 		numLinksOnPage = float(len(masterPageLinks[page.lower()]))
# 		if numLinksOnPage == 1:
# 			numLinksOnPage = float(len(masterPageLinks[masterPageLinks[page.lower()][0].lower()]))
# 		directPages_normalized[page] = numHits/numLinksOnPage
# 	except:
# 		# print page.lower()
# 		directPages_normalized[page] = 0
# 		# print "Oops. Error"

# pickle.dump( directPages_normalized, open( "../datasets/directPages_normalized.p", "wb" ) )
# directPages_normalized_sorted = sorted(directPages_normalized.iteritems(), key=operator.itemgetter(1), reverse=True)
# pickle.dump( directPages_normalized_sorted, open( "../datasets/directPages_normalized_sorted.p", "wb" ) )

# print "Top Ten Direct Pages Normalized"
# print directPages_normalized_sorted[0:10]
# print "------------------------------"

# # -------------

# for page in firsthopPages_normalized:
# 	try:
# 		numHits = float(firsthopPages_normalized[page])
# 		numLinksOnPage = float(len(masterPageLinks[page.lower()]))
# 		if numLinksOnPage == 1:
# 			numLinksOnPage = float(len(masterPageLinks[masterPageLinks[page.lower()][0].lower()]))
# 		firsthopPages_normalized[page] = numHits/numLinksOnPage
# 	except:
# 		firsthopPages_normalized[page] = 0

# firsthopPages_normalized_sorted = sorted(firsthopPages_normalized.iteritems(), key=operator.itemgetter(1), reverse=True)
# pickle.dump( firsthopPages_normalized_sorted, open( "../datasets/firsthopPages_normalized_sorted.p", "wb" ) )
# print "Top Ten First Hop Pages Normalized"
# print firsthopPages_normalized_sorted[0:10]
# print "------------------------------"

# # -------------

# for page in secondhopPages_normalized:
# 	try:
# 		numHits = float(secondhopPages_normalized[page])
# 		numLinksOnPage = float(len(masterPageLinks[page.lower()]))
# 		if numLinksOnPage == 1:
# 			numLinksOnPage = float(len(masterPageLinks[masterPageLinks[page.lower()][0].lower()]))
# 			print page
# 		secondhopPages_normalized[page] = numHits/numLinksOnPage
# 	except:
# 		secondhopPages_normalized[page] = 0

# secondhopPages_normalized_sorted = sorted(secondhopPages_normalized.iteritems(), key=operator.itemgetter(1), reverse=True)
# pickle.dump( secondhopPages_normalized_sorted, open( "../datasets/secondhopPages_normalized_sorted.p", "wb" ) )
# print "Top Ten Second Hop Pages Normalized"
# print secondhopPages_normalized_sorted[0:10]
# print "------------------------------"

# # End Normalize Page Count
# # ------------------------------






# Total Number of pages
# Top 10 hits
# Num pages with only 1 hit
# Page with most hits has N hits


# Analysis on Direct Pages (pages visited by the user)

print "Beginning Direct Page Analysis"
print "------------------------------"

directPages = pickle.load(open("../datasets/directPages.p", "rb")) 
directPages_normalized_sorted = pickle.load(open("../datasets/directPages_normalized_sorted.p", "rb")) 

print "Total Number of Pages: " + str(len(directPages))

directPages_sorted = sorted(directPages.iteritems(), key=operator.itemgetter(1), reverse=True)
maxHits_direct = max(directPages.iteritems(), key=operator.itemgetter(1))[1]

print "The page with the most hits has " + str(maxHits_direct) + " hits."

print "Top ten results:"
pprint(directPages_sorted[0:10])
print "Top ten normalized results:"
pprint(directPages_normalized_sorted[0:10])
print "Finished Direct Page Analysis"
print "------------------------------"




# Analysis on 1st Hop Pages
print "Beginning First Hop Page Analysis"
print "------------------------------"
firsthopPages = pickle.load(open("../datasets/firsthopPages.p", "rb"))
firsthopPages_normalized_sorted = pickle.load(open("../datasets/firsthopPages_normalized_sorted.p", "rb")) 
print "Total Number of Pages: " + str(len(firsthopPages))
firsthopPages_sorted = sorted(firsthopPages.iteritems(), key=operator.itemgetter(1), reverse=True)
maxHits_first = max(firsthopPages.iteritems(), key=operator.itemgetter(1))[1]
print "The page with the most hits has " + str(maxHits_first) + " hits."
print "Top ten results:"
pprint(firsthopPages_sorted[100:110])
print "Top ten normalized results:"
pprint(firsthopPages_normalized_sorted[100:110])
print "Finished First Hop Page Analysis"
print "------------------------------"



# Analysis on 2st Hop Pages
print "Beginning Second Hop Page Analysis"
print "------------------------------"

secondhopPages = pickle.load(open("../datasets/secondhopPages.p", "rb"))
secondhopPages_normalized_sorted = pickle.load(open("../datasets/secondhopPages_normalized_sorted.p", "rb")) 

print "Total Number of Pages: " + str(len(secondhopPages))

firsthopPages_sorted = sorted(secondhopPages.iteritems(), key=operator.itemgetter(1), reverse=True)
maxHits_second = max(secondhopPages.iteritems(), key=operator.itemgetter(1))[1]

print "The page with the most hits has " + str(maxHits_second) + " hits."

print "Top ten results:"
pprint(firsthopPages_sorted[0:10])

print "Top ten normalized results:"
pprint(secondhopPages_normalized_sorted[0:10])


print "Finished Second Hop Page Analysis"
print "------------------------------"

















# #  Data for directPages link count
# maxCount = directPages[max(directPages.iteritems(), key=operator.itemgetter(1))[0]]
# directlinkCountArray = [0]*maxCount # each index (N) represents having N+1 number of links. The value of that index represents how many sites contain N+1 links

# for item in directPages:
# 	directlinkCountArray[directPages[item]-1] += 1


# #  Data for firsthopPages link count
# maxCount = firsthopPages[max(firsthopPages.iteritems(), key=operator.itemgetter(1))[0]]
# firstlinkCountArray = [0]*maxCount # each index (N) represents having N+1 number of links. The value of that index represents how many sites contain N+1 links

# for item in firsthopPages:
# 	firstlinkCountArray[firsthopPages[item]-1] += 1


# #  Data for secondhopPages link count
# maxCount = secondhopPages[max(secondhopPages.iteritems(), key=operator.itemgetter(1))[0]]
# secondlinkCountArray = [0]*maxCount # each index (N) represents having N+1 number of links. The value of that index represents how many sites contain N+1 links

# for item in secondhopPages:
# 	secondlinkCountArray[secondhopPages[item]-1] += 1


# sorted_direct = sorted(directPages.iteritems(), key=operator.itemgetter(1), reverse=True)
# # max(directPages.iteritems(), key=operator.itemgetter(1))[0]
# # print sorted_direct

# sorted_first = sorted(firsthopPages.iteritems(), key=operator.itemgetter(1), reverse=True)
# # max(directPages.iteritems(), key=operator.itemgetter(1))[0]
# # print sorted_x

# sorted_second = sorted(secondhopPages.iteritems(), key=operator.itemgetter(1), reverse=True)
# # max(directPages.iteritems(), key=operator.itemgetter(1))[0]
# # print sorted_x

# pickle.dump( sorted_direct, open( "sorted_direct.p", "wb" ) )
# pickle.dump( sorted_first, open( "sorted_first.p", "wb" ) )
# pickle.dump( sorted_second, open( "sorted_second.p", "wb" ) )


# import pickle
# import numpy as np
# import matplotlib.pyplot as plt

# sorted_direct = pickle.load(open("sorted_direct.p", "rb"))	
# sorted_first = pickle.load(open("sorted_first.p", "rb"))	
# sorted_second = pickle.load(open("sorted_second.p", "rb"))	

# x_direct = []
# x_first = []
# x_second = []

# for item in sorted_direct:
# 	x_direct.append(item[1])

# for item in sorted_first:
# 	x_first.append(item[1])

# for item in sorted_second:
# 	x_second.append(item[1])

# linkStrengthList = {}