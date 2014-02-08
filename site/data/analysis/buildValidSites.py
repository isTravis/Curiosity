import sys
import json
import requests
from datetime import datetime
import urllib



# in_file = open("eng_cropped5", 'r')
in_file = open("../datasets/wikiDataSets/eng_cropped5", 'r')
outfile = open('../datasets/wikiDataSets/validPages4','w')
badfile = open('../datasets/wikiDataSets/validPages4_bad','w')
count = 0


breakcount = 0
titleList = 'garbagejustofrhtefirstthing'
titles = {}
fromts = []
titleListCount = 50
startTime = datetime.now()

viewCounts = []
badpages = 0

for lineItem in in_file.readlines():
	# print lineItem
	
	if titleListCount < 50:
		origTitle = lineItem.split(' ')[0].strip()
		viewCount = lineItem.split(' ')[1].strip()
		titleList += "|" + origTitle
		titleListCount += 1
		# viewCounts.append(viewCount)
		titles[urllib.quote(origTitle)] = {'title': origTitle, 'viewCount': viewCount, 'origTitle': origTitle}
	else:
		# print titles
		try:
			# print "---------"
			# print titleList
			apiURL = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urllib.quote(titleList,safe='|') + '&redirects'
			# apiURL = urllib.quote(titleList)
			# print apiURL
			# 'Do da scraping'
			# print apiURL
			# print urllib.quote(titleList)
			r = requests.get(apiURL)

			# print r
			# print "call the pages"
			# print "here1"
			# print r.json()

			try:
				for child in r.json()['query']['normalized']:
					# print "here?"
					try:
						# print "herea"
						fromt = child['from']
						# print "hereb"
						tot = child['to']
						# print "herec"
						titles[urllib.quote(tot)] = titles[urllib.quote(fromt)]
						# print "hered"
						titles[urllib.quote(tot)]['title'] = tot
						# print "hered"
						fromts.append(titles[urllib.quote(fromt)])
					except:
						ppp =6
			except:
				x = 5


				# print "here"
				
				# print "fromt " + fromt
				# print "tot " + tot
				# # print child['to']
				# # print titles[fromt]

				# print titles.keys()
				# try:
				# 	print titles[fromt]
					
				# except:
				# 	print "caught an oops1"
				# 	print urllib.quote(fromt,safe=' ')
				# 	titles[tot] = titles[urllib.quote(fromt,safe=' ')]
				# 	print "poast1"
				# 	titles[(tot)]['title'] = (tot)
				# 	print "post2"
				# 	# del titles[urllib.quote(fromt,safe=' ')]
				# 	fromts.append(titles[urllib.quote(fromt,safe=' ')])
				# 	print "caught an oops"
					
					# print (urllib.quote_plus(fromt))

				# print "well that worked"
				# titles[tot] = titles[fromt]
				# print "after line 1"
				# titles[tot]['title'] = tot
				# # print titles[tot]
				# print "about to delete"
				

			# print "call the redirects"
			try:
				for child in r.json()['query']['redirects']:
					try:
						fromt = child['from']
						tot = child['to']
						# print tot
						# print child['to']
						# print titles[fromt]
						titles[urllib.quote(tot)] = titles[urllib.quote(fromt)]
						titles[urllib.quote(tot)]['title'] = tot
						# print titles[tot]
						# del titles[fromt]
						fromts.append(titles[urllib.quote(fromt)])
					except:
						# print "lost a redirect"
						ppp =6
			except:
				lklk= 8
				

			# print titles

			j = r.json()['query']['pages']

			articleNumber = 0
			# print "find article number"
			viewCountIndex = 1
			# print j

			# for children in j:
			# 	print children
			# print "here"
			# There's a bit of a problem in that if two titles redirect to a single page, we don't add their viewCounts to a single thing.
			# print "about to child of j"
			# print titles
			for children in j:
				# print children
				articleNumber = children
				# print articleNumber
				# print "here1"
				if int(articleNumber) > 0:
					try:
						# print "yes"
						# print "here2"
						urltitle = ''
						sourcetitle = j[articleNumber]['title']
						# print sourcetitle
						titles[urllib.quote(sourcetitle)]['pageID'] = articleNumber
						# print titles[sourcetitle]
						# print "replace title"
						# print "here3"
						mtitle = j[articleNumber]['title'].replace(' ', '_')
						# try:
						# print "here4"
						# string = urltitle + " | " + articleNumber + " | " + mtitle + " | " + lineItem.split(' ')[1].strip() + "\n"
						# printstring = urltitle + " | " + articleNumber + " | " + mtitle + " | " + lineItem.split(' ')[1].strip()
						# outfile.write(string.encode('utf-8'))
						# print printstring.encode('utf-8')
						# print "construct output"
						# properOutput = articleNumber + " | " + mtitle + " | " + lineItem.split(' ')[1].strip() + "\n"
						# properOutput = articleNumber + " | " + mtitle + " | " + viewCounts[viewCountIndex] + "\n"
						# print "here5"
						properOutput = articleNumber + " | " + mtitle + " | " + titles[urllib.quote(sourcetitle)]['origTitle'] + " | " + titles[urllib.quote(sourcetitle)]['viewCount'] + "\n"
						# Need to make an array of all the values, 
						# Need to correlate the title to the id, need to also check for redirects each time
						# print "here6"
						# print  "write to file"
						outfile.write(properOutput.encode('utf-8'))
					except: 
						# print "lost a page"
						# print j[articleNumber]['title']
						kkk = 9
				else:
					badpages += 1
				viewCountIndex += 1


		except Exception as e:
			# print "inexcept"
			print "in an oops..."
			print type(e)
			for title in titleList.split('|'):
				try:
					properOutput = title + "\n"
					badfile.write(properOutput.encode('utf-8'))
					# urltitle = title

					# apiURL = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urltitle + '&redirects'
					# r = requests.get(apiURL)
					# j = r.json()['query']['pages']

					# articleNumber = 0
					# for children in j:
					# 	articleNumber = children
					# 	if int(articleNumber) > 0:
					# 		mtitle = j[articleNumber]['title'].replace(' ', '_')
					# 		properOutput = articleNumber + " | " + mtitle + " | " + lineItem.split(' ')[0].strip() + " | " + lineItem.split(' ')[1].strip() + "\n"
					# 		outfile.write(properOutput.encode('utf-8'))
				except:
					print "Found a bad site: " + title


		origTitle = lineItem.split(' ')[0].strip()
		viewCount = lineItem.split(' ')[1].strip()
		titleList = origTitle
		titleListCount = 1
		# viewCounts.append(viewCount)
		titles = {}
		titles[urllib.quote(origTitle)] = {'title': origTitle, 'viewCount': viewCount, 'origTitle': origTitle}



	# print breakcount
	# if breakcount > 10000:
	# 	break
	# breakcount += 1

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
print "Bad Pages: " + str(badpages)
