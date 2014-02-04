import sys
import json
import requests
from datetime import datetime
import urllib









# in_file = open("eng_cropped5", 'r')
in_file = open("testingpage", 'r')
outfile = open('validPages2','w')
count = 0


breakcount = 0
titleList = 'garbagejustofrhtefirstthing'
titleListCount = 50
startTime = datetime.now()

viewCounts = []


for lineItem in in_file.readlines():
	if titleListCount < 50:
		titleList += "|" + lineItem.split(' ')[0].strip()
		titleListCount += 1
		viewCounts.append(lineItem.split(' ')[1].strip())
	else:
		try:
			# print titleList
			apiURL = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + titleList + '&redirects'
			# 'Do da scraping'
			# print apiURL
			# print urllib.quote(titleList)
			r = requests.get(apiURL)

			# print r
			# print "call the pages"
			j = r.json()['query']['pages']

			articleNumber = 0
			# print "find article number"
			viewCountIndex = 1
			for children in j:
				articleNumber = children
				# print articleNumber
				if int(articleNumber) > 0:
					# print "yes"
					urltitle = ''
					# print "replace title"
					mtitle = j[articleNumber]['title'].replace(' ', '_')
					# try:
					# string = urltitle + " | " + articleNumber + " | " + mtitle + " | " + lineItem.split(' ')[1].strip() + "\n"
					# printstring = urltitle + " | " + articleNumber + " | " + mtitle + " | " + lineItem.split(' ')[1].strip()
					# outfile.write(string.encode('utf-8'))
					# print printstring.encode('utf-8')
					# print "construct output"
					# properOutput = articleNumber + " | " + mtitle + " | " + lineItem.split(' ')[1].strip() + "\n"
					properOutput = articleNumber + " | " + mtitle + " | " + viewCounts[viewCountIndex] + "\n"
					# Need to make an array of all the values, 
					# Need to correlate the title to the id, need to also check for redirects each time

					# print  "write to file"
					outfile.write(properOutput.encode('utf-8'))
				viewCountIndex += 1

		except:
			# print "in an oops..."
			for title in titleList.split('|'):
				try:
					
					urltitle = title

					apiURL = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urltitle + '&redirects'
					r = requests.get(apiURL)
					j = r.json()['query']['pages']

					articleNumber = 0
					for children in j:
						articleNumber = children
						if int(articleNumber) > 0:
							mtitle = j[articleNumber]['title'].replace(' ', '_')
							properOutput = articleNumber + " | " + mtitle + " | " + lineItem.split(' ')[1].strip() + "\n"
							outfile.write(properOutput.encode('utf-8'))
				except:
					print "Found a bad site: " + title

		titleList = lineItem.split(' ')[0].strip()
		titleListCount = 1
		viewCount = [lineItem.split(' ')[1].strip()]




	# print breakcount
	if breakcount > 160:
		break
	breakcount += 1

	count += 1

	if count % 10000 == 0:
		print count




	# print "Just started a line"
	# try:
	# 	print "Splitting line"
	# 	urltitle = lineItem.split(' ')[0].strip()

	# 	apiURL = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urltitle + '&redirects'
	# 	print "Getting requests"
	# 	r = requests.get(apiURL)
	# 	print "call the pages"
	# 	j = r.json()['query']['pages']

	# 	articleNumber = 0
	# 	print "find article number"
	# 	for children in j:
	# 		articleNumber = children

	# 	print "check article"
	# 	if int(articleNumber) > 0:
	# 		# print "yes"
	# 		print "replace title"
	# 		mtitle = j[articleNumber]['title'].replace(' ', '_')
	# 		# try:
	# 		# string = urltitle + " | " + articleNumber + " | " + mtitle + " | " + lineItem.split(' ')[1].strip() + "\n"
	# 		# printstring = urltitle + " | " + articleNumber + " | " + mtitle + " | " + lineItem.split(' ')[1].strip()
	# 		# outfile.write(string.encode('utf-8'))
	# 		# print printstring.encode('utf-8')
	# 		print "construct output"
	# 		properOutput = articleNumber + " | " + mtitle + " | " + urltitle + " | " + lineItem.split(' ')[1].strip() + "\n"
	# 		print  "write to file"
	# 		outfile.write(properOutput.encode('utf-8'))
			

		# if count > 1001:
		# 	break
	
	# except:
	# 	print "Unexpected error:", sys.exc_info()[0]
	# 	print lineItem
	# 	# try:
	# 	# 	print urltitle + " | " + articleNumber + " | " + mtitle.encode('utf-8') + " | " + lineItem.split(' ')[1].strip()
	# 	# except UnicodeDecodeError:
	# 	# 	print urltitle + " | " + articleNumber + " | " + "titleError" + " | " + lineItem.split(' ')[1].strip()
	

	# count += 1

	# if count % 1000 == 0:
	# 	print count

# 	# else:
# 	# 	print "No Good! " + urltitle


outfile.close()
print(datetime.now()-startTime)	
